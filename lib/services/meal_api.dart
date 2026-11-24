
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';

class MealApi {
  static const String baseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  // Common API request handler
  Future<Map<String, dynamic>> _getJson(Uri url) async {
    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception(
          'Server error: HTTP ${response.statusCode}',
        );
      }

      final data = jsonDecode(response.body);

      if (data is! Map<String, dynamic>) {
        throw const FormatException('Invalid API response');
      }

      return data;
    } on SocketException {
      throw Exception(
        'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      throw Exception(
        'Request timed out. Please try again.',
      );
    } on http.ClientException {
      throw Exception(
        'Network error. Please try again.',
      );
    } on FormatException {
      throw Exception(
        'Invalid data received from the server.',
      );
    }
  }

  // 1. Get all food categories
  Future<List<Category>> getCategories() async {
    final url = Uri.parse('$baseUrl/categories.php');

    final data = await _getJson(url);
    final categories = data['categories'];

    if (categories is! List) {
      throw Exception('Unable to load food categories.');
    }

    return categories
        .map((item) => Category.fromJson(item))
        .toList();
  }

  // 2. Get meals by category
  Future<List<Meal>> getMealsByCategory(String category) async {
    final url = Uri.parse(
      '$baseUrl/filter.php?c=${Uri.encodeQueryComponent(category)}',
    );

    final data = await _getJson(url);
    final meals = data['meals'] ?? [];

    if (meals is! List) {
      throw Exception('Invalid meal data received.');
    }

    return meals.map((item) => Meal.fromJson(item)).toList();
  }

  // 3. Get complete meal details
  Future<Meal?> getMealDetails(String id) async {
    final url = Uri.parse('$baseUrl/lookup.php?i=$id');

    final data = await _getJson(url);
    final meals = data['meals'];

    if (meals == null || meals.isEmpty) {
      return null;
    }

    return Meal.fromJson(meals[0]);
  }

  // 4. Get one random recipe
  Future<Meal?> getRandomMeal() async {
    final url = Uri.parse('$baseUrl/random.php');

    final data = await _getJson(url);
    final meals = data['meals'];

    if (meals == null || meals.isEmpty) {
      return null;
    }

    return Meal.fromJson(meals[0]);
  }

  // 5. Search meals
  Future<List<Meal>> searchMeals(String query) async {
    final url = Uri.parse(
      '$baseUrl/search.php?s=${Uri.encodeQueryComponent(query)}',
    );

    final data = await _getJson(url);
    final meals = data['meals'] ?? [];

    if (meals is! List) {
      throw Exception('Invalid search results received.');
    }

    return meals.map((item) => Meal.fromJson(item)).toList();
  }
}
