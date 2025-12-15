import 'package:flutter/material.dart';
import 'package:mensa_upb/dish.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';

class DishPage extends StatelessWidget {
  final Dish dish;

  const DishPage({
    super.key,
    required this.dish,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    final vegan = dish.vegan ?? false;
    final vegetarian = dish.vegetarian ?? false;
    final dishType = DishType.fromBooleans(vegetarian, vegan);

    final screenSize = MediaQuery.of(context).size;

    final double imageHeight =
        (screenSize.height / 2.5).floorToDouble().clamp(250.0, 500.0);

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: dish.imageSrc != null
          ? Image.network(
              dish.imageSrc!,
              height: imageHeight,
              width: null,
              fit: BoxFit.fitHeight,
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
          // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                ...(dish.canteens ?? []).map((canteen) => Chip(
                      backgroundColor: Colors.blue.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.transparent),
                      ),
                      label:
                          Text(canteen, style: const TextStyle(fontSize: 14)),
                    ))
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (dish.price ?? Prices()).map.entries.map((entry) {
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
                        '${entry.value.replaceAll('.', ',')}€',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
