import 'package:flutter/material.dart';
import 'package:mensa_upb/dish_card.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';
import 'package:mensa_upb/menu_fetcher.dart';
import 'package:mensa_upb/orientation_list.dart';
import 'package:mensa_upb/user_selection.dart';
import 'package:provider/provider.dart';

class MenuList extends StatelessWidget {
  final DateTime date;

  const MenuList({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Consumer<UserSelectionModel>(
      builder: (context, userSelection, child) => FutureBuilder(
        future: MenuFetcher.fetchMenu(
          userSelection.selectedCanteens,
          date,
        ),
        builder: (context, snapshot) {
          var errorColor = Theme.of(context).colorScheme.error;
          var menuFetchErrorWidget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 50,
                color: errorColor,
              ),
              Text(
                localizations.menuFetchErrorMessage,
                textScaler: const TextScaler.linear(2),
                textAlign: TextAlign.center,
                style: TextStyle(color: errorColor),
              ),
            ],
          );
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return menuFetchErrorWidget;
            }

            var json = snapshot.data!;
            var dishes = [
              ...json.mainDishes ?? [],
              ...json.sideDishes ?? [],
              ...json.desserts ?? []
            ];

            if (dishes.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.timer_off_outlined,
                    size: 50,
                    color: Colors.grey,
                  ),
                  Text(
                    localizations.canteenClosedMessage,
                    textScaler: const TextScaler.linear(2),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              );
            }

            var filteredDishes = dishes
                .where((dish) => dish.matchesFilter(userSelection.dishFilter))
                .toList();

            if (filteredDishes.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.filter_alt_off,
                    size: 50,
                    color: Colors.grey,
                  ),
                  Text(
                    localizations.noDishesMatchingFilterMessage,
                    textScaler: const TextScaler.linear(2),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              );
            }

            return FractionallySizedBox(
              widthFactor: 0.9,
              child: OrientationList(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                children: filteredDishes
                    .map(
                      (dish) => DishCard(
                        dish: dish,
                      ),
                    )
                    .toList(),
              ),
            );
          } else if (snapshot.hasError) {
            return menuFetchErrorWidget;
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
