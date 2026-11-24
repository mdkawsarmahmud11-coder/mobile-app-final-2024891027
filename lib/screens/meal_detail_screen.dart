
import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/meal_api.dart';
import '../services/favorites_storage.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({
    super.key,
    required this.mealId,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealApi mealApi = MealApi();
  final FavoritesStorage favoritesStorage = FavoritesStorage();

  Meal? meal;

  bool isLoading = true;
  bool isFavorite = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadMealDetails();
  }

  // Get complete meal details from the API
  Future<void> loadMealDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      Meal? result = await mealApi.getMealDetails(widget.mealId);

      bool favoriteStatus =
          await favoritesStorage.isFavorite(widget.mealId);

      if (!mounted) return;

      setState(() {
        meal = result;
        isFavorite = favoriteStatus;
        isLoading = false;

        if (result == null) {
          errorMessage = 'Meal details not found.';
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load recipe details. Please try again.';
        isLoading = false;
      });
    }
  }

  // Add or remove a recipe from favorites
  Future<void> toggleFavorite() async {
    bool result =
        await favoritesStorage.toggleFavorite(widget.mealId);

    if (!mounted) return;

    setState(() {
      isFavorite = result;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? 'Added to Favorites!'
              : 'Removed from Favorites!',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        centerTitle: true,
        actions: [
          if (meal != null)
            IconButton(
              onPressed: toggleFavorite,
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
                size: 27,
              ),
              tooltip: isFavorite
                  ? 'Remove from Favorites'
                  : 'Add to Favorites',
            ),
        ],
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: loadMealDetails,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : meal == null
                  ? const Center(
                      child: Text('Recipe not available.'),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Meal Image
                          Image.network(
                            meal!.image,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                height: 250,
                                child: Center(
                                  child: Icon(
                                    Icons.restaurant,
                                    size: 70,
                                    color: Colors.orange,
                                  ),
                                ),
                              );
                            },
                          ),

                          // Meal Name
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  meal!.name,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Category and Area
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.category,
                                      color: Colors.orange,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(meal!.category),

                                    const SizedBox(width: 20),

                                    const Icon(
                                      Icons.public,
                                      color: Colors.orange,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(meal!.area),
                                  ],
                                ),

                                const SizedBox(height: 25),

                                // Ingredients Heading
                                const Text(
                                  'Ingredients',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Ingredients List
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemCount: meal!.ingredients.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.orange,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 10),

                                          Expanded(
                                            child: Text(
                                              meal!.ingredients[index],
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),

                                          Text(
                                            meal!.measures[index],
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 25),

                                // Instructions Heading
                                const Text(
                                  'Cooking Instructions',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Instructions
                                Text(
                                  meal!.instructions,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.6,
                                  ),
                                ),

                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
