import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';
import 'package:mensa_upb/nutrition_fetcher.dart';

class NutritionInformationDisplay extends StatelessWidget {
  final Future<NutritionInfo?> nutritionInfo;

  const NutritionInformationDisplay({super.key, required this.nutritionInfo});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          localizations.nutritionHeader,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        FutureBuilder(
            future: nutritionInfo,
            builder: (context, snapshot) {
              var errorColor = theme.colorScheme.error;
              var nutritionFetchErrorWidget = Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 50,
                    color: errorColor,
                  ),
                  Text(
                    localizations.nutritionFetchErrorMessage,
                    style: TextStyle(color: errorColor),
                    textScaler: const TextScaler.linear(1.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              );

              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return nutritionFetchErrorWidget;
                }

                final nutrition = snapshot.data!;

                final locale = Localizations.localeOf(context).toString();
                final decimalPattern = NumberFormat.decimalPattern(locale);

                final kjoules = nutrition.kjoules != null
                    ? decimalPattern
                        .format(num.parse(nutrition.kjoules.toString()))
                    : null;
                final kcalories = nutrition.kcalories != null
                    ? decimalPattern
                        .format(num.parse(nutrition.kcalories.toString()))
                    : null;
                final proteins = nutrition.proteins != null
                    ? decimalPattern
                        .format(num.parse(nutrition.proteins.toString()))
                    : null;
                final carbohydrates = nutrition.carbohydrates != null
                    ? decimalPattern
                        .format(num.parse(nutrition.carbohydrates.toString()))
                    : null;
                final fats = nutrition.fats != null
                    ? decimalPattern
                        .format(num.parse(nutrition.fats.toString()))
                    : null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.nutritionEnergy(
                        kjoules ?? '---', kcalories ?? '---')),
                    Text(localizations.nutritionProtein(proteins ?? '---')),
                    Text(localizations
                        .nutritionCarbohydrates(carbohydrates ?? '---')),
                    Text(localizations.nutritionFat(fats ?? '---')),
                  ],
                );
              } else {
                return Text(
                  localizations.loadingMessage,
                );
              }
            })
      ],
    );
  }
}
