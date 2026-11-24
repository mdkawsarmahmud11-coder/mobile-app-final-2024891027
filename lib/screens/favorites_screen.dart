
import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/meal_api.dart';
import '../services/favorites_storage.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final MealApi mealApi = MealApi();
  final FavoritesStorage favoritesStorage = FavoritesStorage();

  List<Meal> favoriteMeals = [];

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  // Load all saved favorite recipes
  Future<void> loadFavorites() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      List<String> favoriteIds =
          await favoritesStorage.getFavoriteIds();

      List<Meal> loadedMeals = [];

      for (String id in favoriteIds) {
        Meal? meal = await mealApi.getMealDetails(id);

        if (meal != null) {
          loadedMeals.add(meal);
        }
      }

      if (!mounted) return;

      setState(() {
        favoriteMeals = loadedMeals;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load favorites. Please try again.';
        isLoading = false;
      });
    }
  }

  // Remove a recipe from favorites
  Future<void> removeFavorite(String mealId) async {
    await favoritesStorage.removeFavorite(mealId);

    if (!mounted) return;

    setState(() {
      favoriteMeals.removeWhere((meal) => meal.id == mealId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from Favorites!'),
      ),
    );
  }

  // Open recipe details and refresh when returning
  Future<void> openMealDetails(String mealId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailScreen(
          mealId: mealId,
        ),
      ),
    );

    if (mounted) {
      loadFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        centerTitle: true,
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
                        onPressed: loadFavorites,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : favoriteMeals.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 75,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'No Favorite Recipes Yet!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap the heart icon to save recipes.',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: loadFavorites,
                      color: Colors.orange,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: favoriteMeals.length,
                        itemBuilder: (context, index) {
                          Meal meal = favoriteMeals[index];

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
                                  errorBuilder:
                                      (context, error, stackTrace) {
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

                              subtitle: Text(
                                meal.area.isEmpty
                                    ? 'Tap to view recipe'
                                    : meal.area,
                              ),

                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  removeFavorite(meal.id);
                                },
                              ),

                              onTap: () {
                                openMealDetails(meal.id);
                              },
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
