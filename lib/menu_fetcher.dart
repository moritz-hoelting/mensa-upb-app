import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mensa_upb/canteen.dart';
import 'package:mensa_upb/dish.dart';
import 'package:mensa_upb/env/env.dart';

class MenuFetcher {
  static final Map<String, DailyMenu> _menuCache = {};

  static Future<DailyMenu?> fetchMenu(Set<Canteen> canteens, DateTime date,
      {bool forceFetch = false}) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final joinedCanteens =
        canteens.map((canteen) => canteen.identifier).sorted().join(',');

    final cacheKey = '$formattedDate-$joinedCanteens';
    final cachedValue = _menuCache[cacheKey];

    if (forceFetch || cachedValue == null) {
      var res = await http.get(Uri.parse(
        '${Env.mensaApiUrl}/menu/$joinedCanteens?date=$formattedDate',
      ));

      if (res.statusCode != 200) {
        return null;
      }

      var jsonMap = jsonDecode(res.body) as Map<String, dynamic>;

      if (jsonMap['error'] != null) {
        return null;
      }

      var menu = DailyMenu.fromJson(jsonMap);
      _menuCache[cacheKey] = menu;

      return menu;
    } else {
      return cachedValue;
    }
  }
}
