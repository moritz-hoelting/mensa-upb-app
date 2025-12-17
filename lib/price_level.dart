import 'package:flutter/widgets.dart';
import 'package:mensa_upb/dish.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';

enum PriceLevel {
  student,
  employee,
  guest;

  String displayName(BuildContext context) {
    switch (this) {
      case student:
        return AppLocalizations.of(context)!.priceLevelStudent;
      case employee:
        return AppLocalizations.of(context)!.priceLevelEmployee;
      case guest:
        return AppLocalizations.of(context)!.priceLevelGuest;
    }
  }

  String? getFromPrices(Prices? prices) {
    if (prices == null) {
      return null;
    }

    switch (this) {
      case student:
        return prices.students;
      case employee:
        return prices.employees;
      case guest:
        return prices.guests;
    }
  }

  String get plural {
    switch (this) {
      case student:
        return 'students';
      case employee:
        return 'employees';
      case guest:
        return 'guests';
    }
  }
}
