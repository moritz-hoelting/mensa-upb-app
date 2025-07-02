import 'package:flutter/material.dart';

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

    Widget typeIcon;
    if (type != DishType.other) {
      typeIcon = Row(
                  children: [
                    Icon(
                      type == DishType.vegan
                          ? Icons.eco
                          : type == DishType.vegetarian
                              ? Icons.spa
                              : Icons.restaurant,
                      color: type == DishType.vegan
                          ? Colors.green
                          : type == DishType.vegetarian
                              ? Colors.lightGreen
                              : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      type == DishType.vegan
                          ? 'Vegan'
                          : type == DishType.vegetarian
                              ? 'Vegetarian'
                              : 'Other',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                );
    } else {
      typeIcon = const SizedBox.shrink();
    }

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
            child: Column(
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

                const SizedBox(height: 8),

                // Canteen Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: canteens.map((canteen) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        canteen,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black87),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 8),

                // Vegan/Vegetarian Icon
                typeIcon,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum DishType {
  vegan,
  vegetarian,
  other;

  static DishType fromBooleans(bool vegetarian, bool vegan) {
    if (vegan) {
      return DishType.vegan;
    } else if (vegetarian) {
      return DishType.vegetarian;
    } else {
      return DishType.other;
    }
  }
}
