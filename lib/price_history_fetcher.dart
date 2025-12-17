import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mensa_upb/env/env.dart';


class PriceHistoryFetcher {
  static final Map<String, Map<String, Map<DateTime, Map<String, String>>>> _priceHistoryCache = {};

  static Future<Map<String, Map<DateTime, Map<String, String>>>?> fetchPriceHistory(String dishName) async {
    final cacheKey = dishName.toLowerCase();

    final cachedValue = _priceHistoryCache[cacheKey];

    if (cachedValue != null) {
      return cachedValue;
    }

    final encodedName = Uri.encodeComponent(dishName);
    var res = await http.get(Uri.parse('${Env.mensaApiUrl}/price-history/$encodedName'));

    if (res.statusCode != 200) {
      return null;
    }

    var jsonMap = jsonDecode(res.body) as Map<String, dynamic>;
    if (jsonMap['error'] != null) {
      return null;
    }

    _priceHistoryCache[cacheKey] = jsonMap.map((canteenName, canteenPriceHistory) =>
        MapEntry(canteenName, (canteenPriceHistory as Map<String, dynamic>).map((dateStr, prices) =>
            MapEntry(DateTime.parse(dateStr), (prices as Map<String, dynamic>).map((k, v) => MapEntry(k, v.toString()))))));
    return _priceHistoryCache[cacheKey];
  }
}