
import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/meal.dart';
import '../services/meal_api.dart';
import 'meal_list_screen.dart';
import 'meal_detail_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MealApi mealApi = MealApi();

  List<Category> categories = [];

  bool isLoading = true;
  bool isRandomLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  // Get categories from the API
  Future<void> loadCategories() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      List<Category> result = await mealApi.getCategories();

      if (!mounted) return;

      setState(() {
        categories = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load categories. Please try again.';
        isLoading = false;
      });
    }
  }

  // Get a random recipe
  Future<void> getRandomRecipe() async {
    setState(() {
      isRandomLoading = true;
    });

    try {
      Meal? randomMeal = await mealApi.getRandomMeal();

      if (!mounted) return;

      setState(() {
        isRandomLoading = false;
      });

      if (randomMeal == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No random recipe found. Please try again.'),
          ),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealDetailScreen(
            mealId: randomMeal.id,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isRandomLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to load random recipe. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text(
    'Recipe Explorer',
    style: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
  centerTitle: true,

  actions: [
    IconButton(
      icon: const Icon(Icons.info_outline),
      tooltip: 'About',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AboutScreen(),
          ),
        );
      },
    ),
  ],
),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Welcome section
          const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover Delicious Recipes!',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Choose your favorite food category.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Surprise Me Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isRandomLoading ? null : getRandomRecipe,
                icon: isRandomLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.shuffle),
                label: Text(
                  isRandomLoading
                      ? 'Finding a Recipe...'
                      : 'Surprise Me!',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Loading, Error or Categories
          Expanded(
            child: isLoading
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
                              onPressed: loadCategories,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: categories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.90,
                        ),
                        itemBuilder: (context, index) {
                          Category category = categories[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MealListScreen(
                                    categoryName: category.name,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      category.image,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(
                                            Icons.restaurant,
                                            size: 50,
                                            color: Colors.orange,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      category.name,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
