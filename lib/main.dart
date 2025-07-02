import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mensa_upb/dish.dart';
import 'package:mensa_upb/dish_card.dart';
import 'package:mensa_upb/drawer.dart';
import 'package:mensa_upb/user_selection.dart';
import 'package:mensa_upb/env/env.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Mensa UPB',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      // A widget which will be started on application startup
      home: ChangeNotifierProvider(
        create: (context) => UserSelectionModel(),
        child: const MyHomePage(title: 'Mensa UPB'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const MensaSelectionDrawer(),
      bottomNavigationBar: BottomAppBar(
        height: 60.0,
        child: Consumer<UserSelectionModel>(
          builder: (context, userSelection, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                tooltip: 'Previous day',
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  DateTime previousDay = DateUtils.dateOnly(userSelection
                      .selectedDay
                      .subtract(const Duration(days: 1)));
                  if (previousDay
                      .isBefore(DateUtils.dateOnly(DateTime.now()))) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(
                        content: Text('Cannot go back further than today')));
                  } else {
                    userSelection.selectedDay = previousDay;
                  }
                },
              ),
              Text(DateFormat('dd.MM.yyyy').format(userSelection.selectedDay)),
              IconButton(
                tooltip: 'Next day',
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  DateTime limit = DateUtils.dateOnly(DateTime.now())
                      .add(const Duration(days: 7));
                  DateTime nextDay = DateUtils.dateOnly(
                      userSelection.selectedDay.add(const Duration(days: 1)));
                  if (nextDay.isAfter(limit)) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(
                        content: Text('Cannot go back farther than 7 days')));
                  } else {
                    userSelection.selectedDay = nextDay;
                  }
                },
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Consumer<UserSelectionModel>(
          builder: (context, userSelection, child) {
            var canteens = userSelection.selectedCanteens
                .map((e) => e.identifier)
                .join(',');
            var res = http.get(Uri.parse(
              '${Env.mensaApiUrl}/menu/$canteens?date=${DateFormat('yyyy-MM-dd').format(userSelection.selectedDay)}',
            ));

            return FutureBuilder(
                future: res,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var jsonMap =
                        jsonDecode(snapshot.data!.body) as Map<String, dynamic>;

                    if (jsonMap['error'] != null) {
                      return const Text(
                        "An error occured fetching the menu",
                        textScaler: TextScaler.linear(3),
                      );
                    }

                    var json = DailyMenu.fromJson(jsonMap);
                    var dishes = [
                      ...json.mainDishes ?? [],
                      ...json.sideDishes ?? [],
                      ...json.desserts ?? []
                    ];
                    return ListView(
                      scrollDirection: Axis.vertical,
                      children: dishes
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
      ),
    );
  }
}
