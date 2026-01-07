import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mensa_upb/canteen.dart';
import 'package:mensa_upb/dish.dart';
import 'package:mensa_upb/env/env.dart';

class MenuFetcher {
  static final Map<String, DailyMenu> _menuCache = {};
  static DateTime? _firstDate;

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

  static Future<DateTime?> queryFirstDate() async {
    if (_firstDate != null) {
      return _firstDate;
    }

    var res = await http.get(Uri.parse(
      '${Env.mensaApiUrl}/metadata/earliest-meal-date',
    ));

    if (res.statusCode != 200) {
      return DateUtils.dateOnly(DateTime.now())
          .subtract(const Duration(days: 7));
    }

    var jsonMap = jsonDecode(res.body) as Map<String, dynamic>;

    if (jsonMap.isEmpty) {
      return DateUtils.dateOnly(DateTime.now())
          .subtract(const Duration(days: 7));
    }

    var dateString = jsonMap["date"] as String;
    _firstDate = DateTime.parse(dateString);

    return _firstDate;
  }
}
