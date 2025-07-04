import 'package:flutter/material.dart';
import 'package:mensa_upb/dish.dart';
import 'package:mensa_upb/dish_card.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';
import 'package:mensa_upb/menu_fetcher.dart';
import 'package:mensa_upb/orientation_list.dart';
import 'package:mensa_upb/user_selection.dart';
import 'package:provider/provider.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<UserSelectionModel>(
        builder: (context, userSelection, child) {
          var menu = MenuFetcher.fetchMenu(
            userSelection.selectedCanteens,
            userSelection.selectedDay,
          );

          return FutureBuilder(
              future: menu,
              builder: (context, snapshot) {
                var menuFetchErrorWidget = Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.grey,
                    ),
                    Text(
                      AppLocalizations.of(context)!.menuFetchErrorMessage,
                      textScaler: const TextScaler.linear(2),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
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
                          AppLocalizations.of(context)!.canteenClosedMessage,
                          textScaler: const TextScaler.linear(2),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    );
                  }

                  var filteredDishes = dishes
                      .where((dish) =>
                          dish.matchesFilter(userSelection.dishFilter))
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
                          AppLocalizations.of(context)!
                              .noDishesMatchingFilterMessage,
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
                      children: filteredDishes
                          .map(
                            (dish) => DishCard(
                              name: dish.name ?? '---',
                              price: userSelection.priceLevel
                                  .getFromPrices(dish.price ??
                                      Prices(
                                        students: '-',
                                        employees: '-',
                                        guests: '-',
                                      )),
                              imageUrl: dish.imageSrc,
                              canteens: dish.canteens ?? List.empty(),
                              type: DishType.fromBooleans(
                                  dish.vegetarian ?? false,
                                  dish.vegan ?? false),
                            ),
                          )
                          .toList(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return menuFetchErrorWidget;
                } else {
                  return const CircularProgressIndicator();
                }
              });
        },
      ),
    );
  }
}
