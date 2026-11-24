
class Meal {
  String id;
  String name;
  String image;
  String category;
  String area;
  String instructions;
  List<String> ingredients;
  List<String> measures;

  Meal({
    required this.id,
    required this.name,
    required this.image,
    this.category = '',
    this.area = '',
    this.instructions = '',
    this.ingredients = const [],
    this.measures = const [],
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingredientsList = [];
    List<String> measuresList = [];

    for (int i = 1; i <= 20; i++) {
      String ingredient =
          json['strIngredient$i']?.toString().trim() ?? '';

      String measure =
          json['strMeasure$i']?.toString().trim() ?? '';

      if (ingredient.isNotEmpty) {
        ingredientsList.add(ingredient);
        measuresList.add(measure);
      }
    }

    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      image: json['strMealThumb'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      ingredients: ingredientsList,
      measures: measuresList,
    );
  }
}
