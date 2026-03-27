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
      );
}
