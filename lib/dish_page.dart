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

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image or Placeholder
            Hero(
              tag: 'dish-image-${dish.name}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: dish.imageSrc != null
                    ? Image.network(
                        dish.imageSrc!,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 250,
                        width: double.infinity,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[300]
                            : Colors.grey[800],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
              ),
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
                      color: vegan == true ? Colors.green : Colors.lightGreen,
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
