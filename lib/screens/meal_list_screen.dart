
import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/meal_api.dart';
import 'meal_detail_screen.dart';

class MealListScreen extends StatefulWidget {
  final String categoryName;

  const MealListScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  final MealApi mealApi = MealApi();

  List<Meal> meals = [];

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  // Get meals from the selected category
  Future<void> loadMeals() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      List<Meal> result =
          await mealApi.getMealsByCategory(widget.categoryName);

      if (!mounted) return;

      setState(() {
        meals = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load meals. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
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
                        onPressed: loadMeals,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : meals.isEmpty
                  ? const Center(
                      child: Text('No meals found.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        Meal meal = meals[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),

                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                meal.image,
                                width: 85,
                                height: 85,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return const SizedBox(
                                    width: 85,
                                    height: 85,
                                    child: Icon(
                                      Icons.restaurant,
                                      color: Colors.orange,
                                      size: 35,
                                    ),
                                  );
                                },
                              ),
                            ),

                            title: Text(
                              meal.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            subtitle: const Text('Tap to view recipe'),

                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.orange,
                            ),

                            
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MealDetailScreen(
        mealId: meal.id,
      ),
    ),
  );
},

                          ),
                        );
                      },
                    ),
    );
  }
}
