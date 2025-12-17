import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mensa_upb/canteen.dart';
import 'package:mensa_upb/dish.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';
import 'package:mensa_upb/nutrition_fetcher.dart';
import 'package:mensa_upb/nutrition_information_display.dart';

class DishPage extends StatelessWidget {
  final Dish dish;
  final DateTime date;

  const DishPage({
    super.key,
    required this.dish,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final localizations = AppLocalizations.of(context)!;

    final vegan = dish.vegan ?? false;
    final vegetarian = dish.vegetarian ?? false;
    final dishType = DishType.fromBooleans(vegetarian, vegan);

    var priceDecimalPattern =
        NumberFormat.currency(locale: locale, decimalDigits: 2, symbol: '');

    final nutritionInfo =
        NutritionFetcher.fetchNutrition(date, dish.name ?? '');

    final screenSize = MediaQuery.of(context).size;

    final double imageHeight =
        (screenSize.height / 2.5).floorToDouble().clamp(250.0, 500.0);

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: dish.imageSrc != null
          ? FutureBuilder<double>(
              future: getImageAspectRatio(NetworkImage(dish.imageSrc!)),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(height: imageHeight);
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: imageHeight),
                    child: AspectRatio(
                      aspectRatio: snapshot.data!,
                      child: Image.network(
                        dish.imageSrc!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            )
          : Container(
              height: imageHeight,
              width: imageHeight * 1.5,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[300]
                  : Colors.grey[800],
              child: const Icon(
                Icons.image_not_supported,
                size: 80,
                color: Colors.grey,
              ),
            ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: screenSize.width > 500
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.stretch,
          children: [
            // Image or Placeholder
            Hero(
              tag: 'dish-image-${dish.name}',
              child: screenSize.width > 500 ? image : Center(child: image),
            ),
            const SizedBox(height: 16),

            // Price
            Text(
              dish.name ?? '---',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),

            // Canteen Labels
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if ((vegan || vegetarian))
                  Chip(
                    avatar: Icon(
                      vegan ? Icons.eco : Icons.spa,
                      color: dishType.color,
                      size: 20,
                    ),
                    label: Text(
                      vegan == true
                          ? localizations.dishTypeVegan
                          : localizations.dishTypeVegetarian,
                      style: const TextStyle(fontSize: 14),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ...(dish.canteens ?? []).map((canteen) {
                  var canteenName =
                      Canteen.fromIdentifier(canteen.toLowerCase())
                              ?.displayName ??
                          canteen;
                  return Chip(
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.transparent),
                    ),
                    label:
                        Text(canteenName, style: const TextStyle(fontSize: 14)),
                  );
                })
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (dish.price ?? Prices()).map.entries.map((entry) {
                final price =
                    priceDecimalPattern.format(num.parse(entry.value));

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '${entry.key.displayName(context)}:',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$price €',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            NutritionInformationDisplay(nutritionInfo: nutritionInfo),
          ],
        ),
      ),
    );
  }
}

Future<double> getImageAspectRatio(ImageProvider provider) async {
  final completer = Completer<double>();

  final stream = provider.resolve(const ImageConfiguration());
  late final ImageStreamListener listener;

  listener = ImageStreamListener(
    (ImageInfo info, bool _) {
      final image = info.image;
      completer.complete(image.width / image.height);
      stream.removeListener(listener);
    },
    onError: (error, stackTrace) {
      completer.completeError(error, stackTrace);
      stream.removeListener(listener);
    },
  );

  stream.addListener(listener);
  return completer.future;
}
