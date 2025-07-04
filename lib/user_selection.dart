import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:mensa_upb/canteen.dart';
import 'package:mensa_upb/dish.dart';
import 'package:mensa_upb/price_level.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSelectionModel extends ChangeNotifier {
  bool _academicaSelected = true;
  bool _forumSelected = true;
  bool _grillcafeSelected = true;
  bool _zm2Selected = false;
  bool _basilicaSelected = false;
  bool _atriumSelected = false;

  PriceLevel _priceLevel = PriceLevel.student;

  DishType _dishFilter = DishType.other;

  DateTime _selectedDay = DateUtils.dateOnly(DateTime.now());

  late final SharedPreferences _prefs;

  UserSelectionModel() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _academicaSelected = _prefs.getBool(Canteen.academica.preferenceKey) ?? true;
    _forumSelected = _prefs.getBool(Canteen.forum.preferenceKey) ?? true;
    _grillcafeSelected = _prefs.getBool(Canteen.grillCafe.preferenceKey) ?? true;
    _zm2Selected = _prefs.getBool(Canteen.zm2.preferenceKey) ?? false;
    _basilicaSelected = _prefs.getBool(Canteen.basilica.preferenceKey) ?? false;
    _atriumSelected = _prefs.getBool(Canteen.atrium.preferenceKey) ?? false;

    _priceLevel = PriceLevel.values[_prefs.getInt('priceLevelSelected') ?? PriceLevel.student.index];

    _dishFilter = DishType.values[_prefs.getInt('dishFilterSelected') ?? DishType.other.index];

    notifyListeners();
  }

  UnmodifiableMapView<Canteen, bool> get canteens {
    return UnmodifiableMapView({
      Canteen.academica: _academicaSelected,
      Canteen.forum: _forumSelected,
      Canteen.grillCafe: _grillcafeSelected,
      Canteen.zm2: _zm2Selected,
      Canteen.basilica: _basilicaSelected,
      Canteen.atrium: _atriumSelected,
    });
  }

  UnmodifiableSetView<Canteen> get selectedCanteens {
    return UnmodifiableSetView(canteens.entries
        .where((element) => element.value)
        .map((e) => e.key)
        .toSet());
  }

  bool isSelected(Canteen canteen) {
    switch (canteen) {
      case Canteen.academica:
        return _academicaSelected;
      case Canteen.forum:
        return _forumSelected;
      case Canteen.grillCafe:
        return _grillcafeSelected;
      case Canteen.zm2:
        return _zm2Selected;
      case Canteen.basilica:
        return _basilicaSelected;
      case Canteen.atrium:
        return _atriumSelected;
    }
  }

  void set(Canteen canteen, bool value) {
    switch (canteen) {
      case Canteen.academica:
        _academicaSelected = value;
        break;
      case Canteen.forum:
        _forumSelected = value;
        break;
      case Canteen.grillCafe:
        _grillcafeSelected = value;
        break;
      case Canteen.zm2:
        _zm2Selected = value;
        break;
      case Canteen.basilica:
        _basilicaSelected = value;
        break;
      case Canteen.atrium:
        _atriumSelected = value;
        break;
    }
    _prefs.setBool(canteen.preferenceKey, value);
    notifyListeners();
  }

  PriceLevel get priceLevel => _priceLevel;
  set priceLevel(PriceLevel level) {
    _priceLevel = level;
    _prefs.setInt('priceLevelSelected', level.index);
    notifyListeners();
  }

  DishType get dishFilter => _dishFilter;
  set dishFilter(DishType filter) {
    _dishFilter = filter;
    _prefs.setInt('dishFilterSelected', filter.index);
    notifyListeners();
  }

  DateTime get selectedDay => _selectedDay;
  set selectedDay(DateTime day) {
    _selectedDay = DateUtils.dateOnly(day);
    notifyListeners();
  }
}
