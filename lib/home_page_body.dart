import 'package:flutter/material.dart';
import 'package:mensa_upb/dish.dart';
import 'package:mensa_upb/dish_card.dart';
import 'package:mensa_upb/menu_fetcher.dart';
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
                if (snapshot.hasData) {
                  if (snapshot.data == null) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 50,
                          color: Colors.grey,
                        ),
                        Text(
                          "No menu available for this day",
                          textScaler: TextScaler.linear(2),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    );
                  }

                  var json = snapshot.data!;
                  var dishes = [
                    ...json.mainDishes ?? [],
                    ...json.sideDishes ?? [],
                    ...json.desserts ?? []
                  ];

                  if (dishes.isEmpty) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_off_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                        Text(
                          "Canteen is closed",
                          textScaler: TextScaler.linear(2),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    );
                  }

                  var filteredDishes = dishes
                      .where((dish) =>
                          dish.matchesFilter(userSelection.dishFilter))
                      .toList();

                  if (filteredDishes.isEmpty) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_alt_off,
                          size: 50,
                          color: Colors.grey,
                        ),
                        Text(
                          "No dishes match your filter",
                          textScaler: TextScaler.linear(2),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    );
                  }

                  return ListView(
                    scrollDirection: Axis.vertical,
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
                                dish.vegetarian ?? false, dish.vegan ?? false),
                          ),
                        )
                        .toList(),
                  );
                } else if (snapshot.hasError) {
                  return const Text(
                    "An error occured fetching the menu",
                    textScaler: TextScaler.linear(3),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              });
        },
      ),
    );
  }
}
