
import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;
  final Widget? trailing;

  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            meal.image,
            width: 75,
            height: 75,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                width: 75,
                height: 75,
                child: Icon(
                  Icons.restaurant,
                  color: Colors.orange,
                ),
              );
            },
          ),
        ),
        title: Text(
          meal.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text('Tap to view recipe'),
        trailing: trailing ??
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.orange,
            ),
        onTap: onTap,
      ),
    );
  }
}
