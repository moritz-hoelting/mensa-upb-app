import 'package:flutter/material.dart';
import 'package:mensa_upb/canteen.dart';
import 'package:mensa_upb/dish.dart';
import 'package:mensa_upb/dish_page.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';
import 'package:mensa_upb/user_selection.dart';
import 'package:provider/provider.dart';

class DishCard extends StatelessWidget {
  final Dish dish;

  const DishCard({
    super.key,
    required this.dish,
  });

  @override
  Widget build(BuildContext context) {
    final hideTypeIcon = !(dish.vegan ?? false) && !(dish.vegetarian ?? false);
    final localizations = AppLocalizations.of(context)!;

    const borderRadiusValue = 12.0;
    final borderRadius = BorderRadius.circular(borderRadiusValue);

    return Consumer<UserSelectionModel>(
      builder: (context, userSelection, child) {
        final price = userSelection.priceLevel.getFromPrices(dish.price) ?? '-';
        String formattedPrice = '${price.replaceAll('.', ',')}€';

        return InkWell(
          borderRadius: borderRadius,
          onTap: () => {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DishPage(
                dish: dish,
              ),
            ))
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image or Placeholder
                Hero(
                  tag: 'dish-image-${dish.name}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(borderRadiusValue),
                    ),
                    child: dish.imageSrc != null
                        ? Image.network(
                            dish.imageSrc!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 200,
                            width: double.infinity,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey[300]
                                    : Colors.grey[800],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),

                // Info Section
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Consumer<UserSelectionModel>(
                    builder: (context, userSelection, child) {
                      final hideCanteens =
                          userSelection.selectedCanteens.length <= 1;
                      final dishType = DishType.fromBooleans(
                          dish.vegetarian ?? false, dish.vegan ?? false);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dish Name
                          Text(
                            dish.name ?? '---',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),

                          const SizedBox(height: 6),

                          // Price
                          Text(
                            formattedPrice,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          if (!hideCanteens) const SizedBox(height: 8),

                          // Canteen Chips
                          if (!hideCanteens)
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: (dish.canteens ?? []).map((canteen) {
                                var canteenName = Canteen.fromIdentifier(
                                            canteen.toLowerCase())
                                        ?.displayName ??
                                    canteen;
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    canteenName,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black87),
                                  ),
                                );
                              }).toList(),
                            ),

                          if (!hideTypeIcon) const SizedBox(height: 8),

                          // Vegan/Vegetarian Icon
                          if (!hideTypeIcon)
                            Row(
                              children: [
                                Icon(
                                  dish.vegan == true ? Icons.eco : Icons.spa,
                                  color: dishType.color,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  dish.vegan == true
                                      ? localizations.dishTypeVegan
                                      : localizations.dishTypeVegetarian,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
