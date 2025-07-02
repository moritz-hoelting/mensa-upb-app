import 'package:mensa_upb/dish.dart';

enum PriceLevel {
  student,
  employee,
  guest;

  String get displayName {
    switch (this) {
      case student:
        return 'Student';
      case employee:
        return 'Employee';
      case guest:
        return 'Guest';
    }
  }

  String getFromPrices(Prices prices) {
    switch (this) {
      case student:
        return prices.students ?? '-';
      case employee:
        return prices.employees ?? '-';
      case guest:
        return prices.guests ?? '-';
    }
  }
}
