import 'dart:convert';

import 'package:fixed/fixed.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mensa_upb/env/env.dart';

class NutritionInfo {
  int? kjoules;
  Fixed? proteins;
  Fixed? carbohydrates;
  Fixed? fats;

  NutritionInfo({
    required this.kjoules,
    required this.proteins,
    required this.carbohydrates,
    required this.fats,
  });

  NutritionInfo.fromJson(Map<String, dynamic> json) {
    kjoules = json['kjoules'];
    proteins = json['proteins'] != null ? Fixed.parse(json['proteins'].toString()) : null;
    carbohydrates = json['carbohydrates'] != null ? Fixed.parse(json['carbohydrates'].toString()) : null;
    fats = json['fats'] != null ? Fixed.parse(json['fats'].toString()) : null;
  }

  int? get kcalories {
    if (kjoules == null) return null;
    return (kjoules! / 4.184).round();
  }
}

class NutritionFetcher {
  static final Map<String, NutritionInfo> _nutritionCache = {};

  static Future<NutritionInfo?> fetchNutrition(DateTime date, String dishName) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final cacheKey = '$formattedDate-${dishName.toLowerCase()}';

    final cachedValue = _nutritionCache[cacheKey];

    if (cachedValue != null) {
      return cachedValue;
    }

    final encodedName = Uri.encodeComponent(dishName);
    var res = await http.get(Uri.parse('${Env.mensaApiUrl}/nutrition/$encodedName/?date=$formattedDate'));

    if (res.statusCode != 200) {
      return null;
    }

    var jsonMap = jsonDecode(res.body) as Map<String, dynamic>;
    if (jsonMap['error'] != null) {
      return null;
    }

    var nutrition = NutritionInfo.fromJson(jsonMap);
    _nutritionCache[cacheKey] = nutrition;
    return nutrition;
  }
}