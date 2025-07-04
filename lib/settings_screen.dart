import 'package:flutter/material.dart';
import 'package:mensa_upb/dish.dart';
import 'package:mensa_upb/env/env.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';
import 'package:mensa_upb/price_level.dart';
import 'package:mensa_upb/user_selection.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
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
                title: 'General',
                children: [
                  Consumer<UserSelectionModel>(
                    builder: (context, userSelection, child) =>
                        FractionallySizedBox(
                      alignment: Alignment.center,
                      widthFactor: 0.9,
                      child: Column(
                        spacing: 16.0,
                        children: [
                          DropdownButtonFormField<PriceLevel>(
                            value: userSelection.priceLevel,
                            items: PriceLevel.values
                                .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.displayName(context))))
                                .toList(),
                            onChanged: (value) {
                              userSelection.priceLevel =
                                  value ?? PriceLevel.student;
                            },
                            icon: const Icon(Icons.attach_money),
                            decoration: InputDecoration(
                              labelText:
                                  '${AppLocalizations.of(context)!.priceLevelLabel}:',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          DropdownButtonFormField<DishType>(
                            value: userSelection.dishFilter,
                            items: DishType.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.filterName(context)),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              userSelection.dishFilter =
                                  value ?? DishType.other;
                            },
                            icon: Icon(
                                userSelection.dishFilter == DishType.other
                                    ? Icons.filter_list_off
                                    : Icons.filter_list),
                            decoration: InputDecoration(
                              labelText:
                                  '${AppLocalizations.of(context)!.dishFilterLabel}:',
                              border: OutlineInputBorder(),
                            ),
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
                    title: 'Information',
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
                                        '${packageInfo.appName} version ${packageInfo.version}',
                                        'Made by ${Env.appAuthor}',
                                      ].join('\n'),
                                    ),
                                    Wrap(
                                      spacing: 8.0,
                                      children: [
                                        Env.fundingUrl != null
                                            ? InkWell(
                                                onTap: () async {
                                                  await launchUrl(Uri.parse(
                                                      Env.fundingUrl!));
                                                },
                                                child: Chip(
                                                  label:
                                                      Text('Support this app'),
                                                  avatar: const Icon(
                                                    Icons.favorite,
                                                    color: Colors.redAccent,
                                                  ),
                                                ))
                                            : const SizedBox.shrink(),
                                        InkWell(
                                          onTap: () async {
                                            await launchUrl(
                                                Uri.parse(Env.repositoryUrl));
                                          },
                                          child: Chip(
                                            label: const Text('Open Source'),
                                            avatar: Icon(
                                              Icons.code,
                                              color: Theme.of(context)
                                                  .dividerColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              } else {
                                return const Text('Loading...');
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
