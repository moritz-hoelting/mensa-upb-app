import 'package:flutter/material.dart';
import 'package:mensa_upb/canteen.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';
import 'package:mensa_upb/settings_screen.dart';
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
            padding: EdgeInsets.only(bottom: 16.0),
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 27, 43, 147),
                      const Color.fromARGB(255, 55, 117, 199),
                      const Color.fromARGB(255, 80, 168, 203),
                      const Color.fromARGB(255, 113, 208, 209),
                    ],
                    transform: GradientRotation(-0.5),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.optionsHeader,
                  style: theme.textTheme.headlineLarge
                      ?.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
              ...Canteen.values.map(canteenTileOf),
              const Divider(),
              ListTile(
                title: Text('Settings'),
                leading: const Icon(Icons.settings),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
