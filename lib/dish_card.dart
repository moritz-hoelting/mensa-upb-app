import 'package:flutter/material.dart';
import 'package:mensa_upb/canteen.dart';
import 'package:mensa_upb/dish.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';
import 'package:mensa_upb/user_selection.dart';
import 'package:provider/provider.dart';

class DishCard extends StatelessWidget {
  final String? imageUrl; // nullable
  final String name;
  final String price;
  final List<String> canteens;
  final DishType type;

  const DishCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.canteens,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    String formattedPrice = '${price.replaceAll('.', ',')}€';
    final hideTypeIcon = type == DishType.other;
    final localizations = AppLocalizations.of(context)!;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image or Placeholder
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
          ),

          // Info Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Consumer<UserSelectionModel>(
              builder: (context, userSelection, child) {
                final hideCanteens = userSelection.selectedCanteens.length <= 1;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dish Name
                    Text(
                      name,
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

                    (hideCanteens
                        ? const SizedBox.shrink()
                        : const SizedBox(height: 8)),

                    // Canteen Chips
                    (hideCanteens
                        ? const SizedBox.shrink()
                        : Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: canteens.map((canteen) {
                              var canteenName =
                                  Canteen.fromIdentifier(canteen.toLowerCase())
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
                          )),

                    (hideTypeIcon
                        ? const SizedBox.shrink()
                        : const SizedBox(height: 8)),

                    // Vegan/Vegetarian Icon
                    (hideTypeIcon
                        ? const SizedBox.shrink() as Widget
                        : Row(
                            children: [
                              Icon(
                                type == DishType.vegan ? Icons.eco : Icons.spa,
                                color: type == DishType.vegan
                                    ? Colors.green
                                    : Colors.lightGreen,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                type == DishType.vegan
                                    ? localizations
                                        .dishTypeVegan
                                    : localizations
                                        .dishTypeVegetarian,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ) as Widget),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
