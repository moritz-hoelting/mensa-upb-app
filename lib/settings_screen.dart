import 'package:flutter/material.dart';
import 'package:mensa_upb/dish.dart';
import 'package:mensa_upb/env/env.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';
import 'package:mensa_upb/price_level.dart';
import 'package:mensa_upb/user_selection.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.settingsHeader,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400.0),
          child: ListView(
            children: [
              _Section(
                title: localizations.settingsHeader,
                children: [
                  Consumer<UserSelectionModel>(
                    builder: (context, userSelection, child) =>
                        FractionallySizedBox(
                      alignment: Alignment.center,
                      widthFactor: 0.9,
                      child: Column(
                        spacing: 16.0,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${localizations.priceLevelLabel}:',
                                  style: theme.textTheme.labelLarge),
                              ToggleSwitch(
                                minWidth: double.infinity,
                                dividerColor: theme.dividerColor,
                                totalSwitches: PriceLevel.values.length,
                                initialLabelIndex:
                                    userSelection.priceLevel.index,
                                labels: PriceLevel.values
                                    .map((e) => e.displayName(context))
                                    .toList(),
                                inactiveBgColor:
                                    theme.colorScheme.surfaceContainerHigh,
                                activeBgColor: [theme.colorScheme.primary],
                                activeFgColor: theme.colorScheme.onPrimary,
                                icons: PriceLevel.values
                                    .map((e) => e == PriceLevel.student
                                        ? Icons.school
                                        : e == PriceLevel.employee
                                            ? Icons.work
                                            : Icons.person)
                                    .toList(),
                                onToggle: (index) {
                                  if (index == null) return;
                                  userSelection.priceLevel =
                                      PriceLevel.values[index];
                                },
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${localizations.dishFilterLabel}:',
                                  style: theme.textTheme.labelLarge),
                              ToggleSwitch(
                                minWidth: double.infinity,
                                dividerColor: theme.dividerColor,
                                totalSwitches: DishType.values.length,
                                initialLabelIndex: DishType.values.length -
                                    1 -
                                    userSelection.dishFilter.index,
                                labels: DishType.values.reversed
                                    .map((e) => e.filterName(context))
                                    .toList(),
                                inactiveBgColor:
                                    theme.colorScheme.surfaceContainerHigh,
                                activeBgColors: DishType.values.reversed
                                    .map((e) => e == DishType.other
                                        ? [theme.colorScheme.primary]
                                        : [e.color])
                                    .toList(),
                                activeFgColor:
                                    (userSelection.dishFilter == DishType.other)
                                        ? theme.colorScheme.onPrimary
                                        : Colors.black,
                                icons: DishType.values.reversed
                                    .map((e) => e == DishType.vegan
                                        ? Icons.eco
                                        : e == DishType.vegetarian
                                            ? Icons.spa
                                            : Icons.fastfood)
                                    .toList(),
                                onToggle: (index) {
                                  if (index == null) return;
                                  userSelection.dishFilter =
                                      DishType.values.reversed.toList()[index];
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    child: const Divider(),
                  ),
                  _Section(
                    title: localizations.aboutHeader,
                    children: [
                      ListTile(
                        title: FutureBuilder(
                            future: PackageInfo.fromPlatform(),
                            builder: (context, packageInfoSnapshot) {
                              if (packageInfoSnapshot.hasData) {
                                var packageInfo = packageInfoSnapshot.data!;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      [
                                        localizations.appNameVersionDescriptor(
                                            packageInfo.appName,
                                            packageInfo.version),
                                        localizations
                                            .madeByDescriptor(Env.appAuthor),
                                      ].join('\n'),
                                    ),
                                    Wrap(
                                      spacing: 8.0,
                                      children: [
                                        if (Env.fundingUrl != null)
                                          InputChip(
                                            label: Text(localizations
                                                .supportAppDescriptor),
                                            avatar: const Icon(
                                              Icons.favorite,
                                              color: Colors.redAccent,
                                            ),
                                            onPressed: () async {
                                              await launchUrl(
                                                  Uri.parse(Env.fundingUrl!));
                                            },
                                          ),
                                        InputChip(
                                          label: const Text('Open Source'),
                                          avatar: Icon(
                                            Icons.code,
                                            color:
                                                Theme.of(context).dividerColor,
                                          ),
                                          onPressed: () async {
                                            await launchUrl(
                                                Uri.parse(Env.repositoryUrl));
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              } else {
                                return Text(
                                    '${localizations.loadingMessage}...');
                              }
                            }),
                        leading: const Icon(Icons.info),
                        titleAlignment: ListTileTitleAlignment.top,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _Section({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(children: children),
      ],
    );
  }
}
