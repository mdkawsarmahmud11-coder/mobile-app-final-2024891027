
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStorage {
  static const String favoriteKey = 'favoriteMeals';

  // Get all favorite meal IDs
  Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(favoriteKey) ?? [];
  }

  // Add a meal to favorites
  Future<void> addFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> favorites = prefs.getStringList(favoriteKey) ?? [];

    if (!favorites.contains(mealId)) {
      favorites.add(mealId);
      await prefs.setStringList(favoriteKey, favorites);
    }
  }

  // Remove a meal from favorites
  Future<void> removeFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> favorites = prefs.getStringList(favoriteKey) ?? [];

    favorites.remove(mealId);

    await prefs.setStringList(favoriteKey, favorites);
  }

  // Check whether a meal is already a favorite
  Future<bool> isFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> favorites = prefs.getStringList(favoriteKey) ?? [];

    return favorites.contains(mealId);
  }

  // Add or remove a favorite
  Future<bool> toggleFavorite(String mealId) async {
    bool favorite = await isFavorite(mealId);

    if (favorite) {
      await removeFavorite(mealId);
      return false;
    } else {
      await addFavorite(mealId);
      return true;
    }
  }
}
