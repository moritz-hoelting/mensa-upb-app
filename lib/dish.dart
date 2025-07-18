import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';
import 'package:mensa_upb/price_level.dart';

class DailyMenu {
  String? date;
  List<Dish>? mainDishes;
  List<Dish>? sideDishes;
  List<Dish>? desserts;

  DailyMenu({this.date, this.mainDishes, this.sideDishes, this.desserts});

  DailyMenu.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['main_dishes'] != null) {
      mainDishes = <Dish>[];
      json['main_dishes'].forEach((v) {
        mainDishes!.add(Dish.fromJson(v));
      });
    }
    if (json['side_dishes'] != null) {
      sideDishes = <Dish>[];
      json['side_dishes'].forEach((v) {
        sideDishes!.add(Dish.fromJson(v));
      });
    }
    if (json['desserts'] != null) {
      desserts = <Dish>[];
      json['desserts'].forEach((v) {
        desserts!.add(Dish.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    if (mainDishes != null) {
      data['main_dishes'] = mainDishes!.map((v) => v.toJson()).toList();
    }
    if (sideDishes != null) {
      data['side_dishes'] = sideDishes!.map((v) => v.toJson()).toList();
    }
    if (desserts != null) {
      data['desserts'] = desserts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dish {
  String? name;
  String? imageSrc;
  Prices? price;
  bool? vegetarian;
  bool? vegan;
  List<String>? canteens;

  Dish({
    this.name,
    this.imageSrc,
    this.price,
    this.vegetarian,
    this.vegan,
    this.canteens,
  });

  Dish.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imageSrc = json['image_src'];
    price = json['price'] != null ? Prices.fromJson(json['price']) : null;
    vegetarian = json['vegetarian'];
    vegan = json['vegan'];
    canteens = json['canteens'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image_src'] = imageSrc;
    if (price != null) {
      data['price'] = price!.toJson();
    }
    data['vegetarian'] = vegetarian;
    data['vegan'] = vegan;
    data['canteens'] = canteens;
    return data;
  }

  bool matchesFilter(DishType filter) {
    if (filter == DishType.other) {
      return true;
    }
    if (filter == DishType.vegan && vegan == true) {
      return true;
    }
    if (filter == DishType.vegetarian &&
        (vegetarian == true || vegan == true)) {
      return true;
    }
    return false;
  }
}

class Prices {
  String? students;
  String? employees;
  String? guests;

  Prices({this.students, this.employees, this.guests});

  Prices.fromJson(Map<String, dynamic> json) {
    students = json['students'];
    employees = json['employees'];
    guests = json['guests'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['students'] = students;
    data['employees'] = employees;
    data['guests'] = guests;
    return data;
  }

  Map<PriceLevel, String> get map {
    final Map<PriceLevel, String> map = {};
    if (students != null) {
      map[PriceLevel.student] = students!;
    }
    if (employees != null) {
      map[PriceLevel.employee] = employees!;
    }
    if (guests != null) {
      map[PriceLevel.guest] = guests!;
    }

    return map;
  }
}

enum DishType {
  vegan,
  vegetarian,
  other;

  static DishType fromBooleans(bool vegetarian, bool vegan) {
    if (vegan) {
      return DishType.vegan;
    } else if (vegetarian) {
      return DishType.vegetarian;
    } else {
      return DishType.other;
    }
  }

  String filterName(BuildContext context) {
    switch (this) {
      case DishType.vegan:
        return AppLocalizations.of(context)!.dishTypeVegan;
      case DishType.vegetarian:
        return AppLocalizations.of(context)!.dishTypeVegetarian;
      case DishType.other:
        return AppLocalizations.of(context)!.dishFilterAll;
    }
  }

  Color get color {
    switch (this) {
      case DishType.vegan:
        return Colors.green;
      case DishType.vegetarian:
        return Colors.lightGreen;
      case DishType.other:
        return Colors.grey.shade700;
    }
  }
}
