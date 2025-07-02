import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mensa_upb/canteen.dart';
import 'package:mensa_upb/price_level.dart';

class UserSelectionModel extends ChangeNotifier {
  bool _academicaSelected = true;
  bool _forumSelected = true;
  bool _grillcafeSelected = true;
  bool _zm2Selected = false;
  bool _basilicaSelected = false;
  bool _atriumSelected = false;

  PriceLevel _priceLevel = PriceLevel.student;

  DateTime _selectedDay = DateUtils.dateOnly(DateTime.now());

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
    notifyListeners();
  }

  PriceLevel get priceLevel => _priceLevel;
  set priceLevel(PriceLevel level) {
    _priceLevel = level;
    notifyListeners();
  }

  DateTime get selectedDay => _selectedDay;
  set selectedDay(DateTime day) {
    _selectedDay = DateUtils.dateOnly(day);
    notifyListeners();
  }
}
