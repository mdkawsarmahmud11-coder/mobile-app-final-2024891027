
import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/meal_api.dart';
import 'meal_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MealApi mealApi = MealApi();
  final TextEditingController searchController = TextEditingController();

  List<Meal> meals = [];

  bool isLoading = false;
  bool hasSearched = false;
  String errorMessage = '';

  // Search meals using the API
  Future<void> searchMeals() async {
    if (isLoading) return;

    String query = searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        meals = [];
        hasSearched = false;
        errorMessage = '';
      });
      return;
    }

    setState(() {
      isLoading = true;
      hasSearched = true;
      errorMessage = '';
      meals = [];
    });

    try {
      List<Meal> result = await mealApi.searchMeals(query);

      if (!mounted) return;

      setState(() {
        meals = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage =
            'Unable to search recipes. Please check your internet connection and try again.';
        isLoading = false;
      });
    }
  }

  // Clear search and reset results
  void clearSearch() {
    if (isLoading) return;

    searchController.clear();

    setState(() {
      meals = [];
      hasSearched = false;
      errorMessage = '';
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Recipes'),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                searchMeals();
              },
              decoration: InputDecoration(
                hintText: 'Search for a recipe...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: clearSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          // Search Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : searchMeals,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                ),
                child: Text(
                  isLoading ? 'Searching...' : 'Search',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Search Results
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  )
                : errorMessage.isNotEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.wifi_off,
                                size: 45,
                                color: Colors.orange,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                errorMessage,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: searchMeals,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : !hasSearched
                        ? const Center(
                            child: Text(
                              'Search for your favorite recipes!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : meals.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 50,
                                        color: Colors.orange,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'No recipes found.',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Try another recipe name, such as chicken or pasta.',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(12),
                                itemCount: meals.length,
                                itemBuilder: (context, index) {
                                  Meal meal = meals[index];

                                  return Card(
                                    margin: const EdgeInsets.only(
                                      bottom: 12,
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.all(10),
                                      leading: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10),
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
                                      subtitle: const Text(
                                        'Tap to view recipe',
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.orange,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MealDetailScreen(
                                              mealId: meal.id,
                                            ),
                                          ),
                                        );
                                      },
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
