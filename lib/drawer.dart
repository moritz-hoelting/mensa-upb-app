import 'package:flutter/material.dart';
import 'package:mensa_upb/canteen.dart';
import 'package:mensa_upb/dish.dart';
import 'package:mensa_upb/price_level.dart';
import 'package:mensa_upb/user_selection.dart';
import 'package:provider/provider.dart';

class MensaSelectionDrawer extends StatelessWidget {
  const MensaSelectionDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<UserSelectionModel>(
        builder: (context, userSelection, child) {
          CheckboxListTile canteenTileOf(Canteen canteen) {
            return CheckboxListTile(
              title: Text(canteen.displayName),
              value: userSelection.isSelected(canteen),
              onChanged: (bool? value) {
                userSelection.set(canteen, value ?? false);
              },
            );
          }

          var theme = Theme.of(context);

          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                ),
                child: Text(
                  'Options',
                  style: theme.textTheme.headlineLarge
                      ?.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
              ...Canteen.values.map(canteenTileOf),
              Container(
                padding: const EdgeInsets.only(right: 16.0),
                child: FractionallySizedBox(
                  alignment: Alignment.center,
                  widthFactor: 0.9,
                  child: Column(
                    spacing: 16.0,
                    children: [
                      DropdownButtonFormField<PriceLevel>(
                        value: userSelection.priceLevel,
                        items: PriceLevel.values
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text(e.displayName)))
                            .toList(),
                        onChanged: (value) {
                          userSelection.priceLevel =
                              value ?? PriceLevel.student;
                        },
                        icon: const Icon(Icons.attach_money),
                        decoration: const InputDecoration(
                          labelText: 'Price level:',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      DropdownButtonFormField<DishType>(
                        value: userSelection.dishFilter,
                        items: DishType.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.filterName),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          userSelection.dishFilter = value ?? DishType.other;
                        },
                        icon: Icon(userSelection.dishFilter == DishType.other
                            ? Icons.filter_list_off
                            : Icons.filter_list),
                        decoration: const InputDecoration(
                          labelText: 'Dish filter:',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
