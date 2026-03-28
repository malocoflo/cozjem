class Recipe {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final String imageUrl;
  final List<String> tags;
  final int matchedIngredients;
  final int totalIngredients;
  final bool isBestseller;
  final bool isReady;
  final List<String> requiredIngredients;
  final bool allIngredientsAvailable;

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.imageUrl,
    this.tags = const [],
    required this.matchedIngredients,
    required this.totalIngredients,
    this.isBestseller = false,
    this.isReady = false,
    this.requiredIngredients = const [],
    this.allIngredientsAvailable = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        durationMinutes: json['duration_minutes'] as int,
        imageUrl: json['image_url'] as String,
        tags: List<String>.from(json['tags'] as List? ?? []),
        matchedIngredients: json['matched_ingredients'] as int,
        totalIngredients: json['total_ingredients'] as int,
        isBestseller: json['is_bestseller'] as bool? ?? false,
        isReady: json['is_ready'] as bool? ?? false,
        requiredIngredients:
          List<String>.from(json['required_ingredients'] as List? ?? []),
        allIngredientsAvailable:
          json['all_ingredients_available'] as bool? ?? false,
      );

  factory Recipe.fromApiJson(Map<String, dynamic> json, {required String id}) => Recipe(
        id: id,
        title: json['title'] as String,
        description: json['description'] as String,
        durationMinutes: json['duration_minutes'] as int,
        imageUrl: '',
        tags: List<String>.from(json['tags'] as List? ?? []),
        matchedIngredients: json['matched_ingredients'] as int,
        totalIngredients: json['total_ingredients'] as int,
        requiredIngredients:
          List<String>.from(json['required_ingredients'] as List? ?? []),
        allIngredientsAvailable:
          json['all_ingredients_available'] as bool? ?? false,
      );
}
