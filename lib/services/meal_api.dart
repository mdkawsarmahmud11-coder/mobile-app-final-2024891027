
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';

class MealApi {
  static const String baseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  // 1. Get all food categories
  Future<List<Category>> getCategories() async {
    final url = Uri.parse('$baseUrl/categories.php');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List categories = data['categories'];

      return categories
          .map((item) => Category.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // 2. Get meals by category
  Future<List<Meal>> getMealsByCategory(String category) async {
    final url = Uri.parse(
      '$baseUrl/filter.php?c=${Uri.encodeQueryComponent(category)}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List meals = data['meals'] ?? [];

      return meals.map((item) => Meal.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  // 3. Get complete meal details
  Future<Meal?> getMealDetails(String id) async {
    final url = Uri.parse('$baseUrl/lookup.php?i=$id');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['meals'] == null) {
        return null;
      }

      return Meal.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  // Get one random recipe
  Future<Meal?> getRandomMeal() async {
    final url = Uri.parse('$baseUrl/random.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['meals'] == null) {
        return null;
      }

      return Meal.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load random meal');
    }
  }


  // 4. Search meals
  Future<List<Meal>> searchMeals(String query) async {
    final url = Uri.parse(
      '$baseUrl/search.php?s=${Uri.encodeQueryComponent(query)}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List meals = data['meals'] ?? [];

      return meals.map((item) => Meal.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search meals');
    }
  }
}

