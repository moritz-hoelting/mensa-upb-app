import 'package:collection/collection.dart';

enum Canteen {
  academica,
  forum,
  grillCafe,
  zm2,
  basilica,
  atrium;

  String get identifier {
    switch (this) {
      case academica:
        return "academica";
      case forum:
        return "forum";
      case grillCafe:
        return "grillcafe";
      case zm2:
        return "zm2";
      case basilica:
        return "basilica";
      case atrium:
        return "atrium";
    }
  }

  String get displayName {
    switch (this) {
      case academica:
        return "Academica";
      case forum:
        return "Forum";
      case grillCafe:
        return "Grill | Café";
      case zm2:
        return "ZM2";
      case basilica:
        return "Basilica (Hamm)";
      case atrium:
        return "Atrium (Lippstadt)";
    }
  }

  String get preferenceKey {
    return 'is${identifier.substring(0, 1).toUpperCase()}${identifier.substring(1)}Selected';
  }

  static Canteen? fromIdentifier(String identifier) {
    return Canteen.values.firstWhereOrNull(
      (canteen) => canteen.identifier == identifier,
    );
  }
}
