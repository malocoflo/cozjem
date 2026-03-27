class Ingredient {
  final String name;
  final String category;
  final String confidence;

  const Ingredient({
    required this.name,
    required this.category,
    required this.confidence,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        name: json['name'] as String,
        category: json['category'] as String,
        confidence: json['confidence'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category,
        'confidence': confidence,
      };

  Ingredient copyWith({String? name, String? category, String? confidence}) =>
      Ingredient(
        name: name ?? this.name,
        category: category ?? this.category,
        confidence: confidence ?? this.confidence,
      );
}
