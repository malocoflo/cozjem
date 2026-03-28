import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ingredient_tile.dart';
import '../widgets/ingredient_floating_plate.dart';
import '../widgets/recipe_card.dart';
import 'recipes_screen.dart';

class IngredientsScreen extends StatefulWidget {
  final List<Ingredient> ingredients;
  final File? capturedImage;

  const IngredientsScreen({
    super.key,
    required this.ingredients,
    this.capturedImage,
  });

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  late List<Ingredient> _ingredients;
  final TextEditingController _addController = TextEditingController();
  final ApiService _apiService = ApiService();

  List<Recipe>? _suggestedRecipes;
  bool _loadingRecipes = false;
  String? _recipesError;

  final List<Map<String, dynamic>> _popularAdditions = [
    {'name': 'Ser', 'icon': Icons.circle_outlined},
    {'name': 'Czosnek', 'icon': Icons.spa_outlined},
    {'name': 'Cebula', 'icon': Icons.circle_outlined},
    {'name': 'Masło', 'icon': Icons.rectangle_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _ingredients = List.from(widget.ingredients);
    _fetchRecipes();
  }

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  void _removeIngredient(int index) {
    setState(() => _ingredients.removeAt(index));
  }

  String _ingredientCountText(int count) {
    if (count == 1) return '1 składnik';
    if (count < 5) return '$count składniki';
    return '$count składników';
  }

  void _addIngredient(String name) {
    if (name.trim().isEmpty) return;
    setState(() {
      _ingredients.add(Ingredient(
        name: name.trim(),
        category: 'Inne',
        confidence: 'manual',
      ));
    });
    _addController.clear();
  }

  Future<void> _fetchRecipes() async {
    if (_ingredients.isEmpty) return;
    setState(() {
      _loadingRecipes = true;
      _recipesError = null;
    });
    try {
      final recipes = await _apiService.suggestRecipes(_ingredients);
      if (mounted) setState(() => _suggestedRecipes = recipes);
    } catch (e) {
      if (mounted) setState(() => _recipesError = e.toString());
    } finally {
      if (mounted) setState(() => _loadingRecipes = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.onSurface,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Potwierdź zawartość',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.05 * 12,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Co masz w środku?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            // Fridge image with overlay
            if (widget.capturedImage != null)
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: FileImage(widget.capturedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x00000000),
                        Color(0xCC000000),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Analiza Twojej lodówki zakończona sukcesem.\nZidentyfikowaliśmy ${_ingredientCountText(_ingredients.length)}.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            // Ingredient list
            if (_ingredients.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        size: 48,
                        color: AppColors.outlineVariant,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Brak składników.\nDodaj je ręcznie poniżej.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...List.generate(
                _ingredients.length,
                (i) => IngredientTile(
                  ingredient: _ingredients[i],
                  onRemove: () => _removeIngredient(i),
                ),
              ),
            const SizedBox(height: 16),
            // ── Suggested recipes section ──────────────────────────
            Row(
              children: [
                Text(
                  'Przepisy dla Ciebie',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const Spacer(),
                if (!_loadingRecipes)
                  GestureDetector(
                    onTap: _fetchRecipes,
                    child: const Icon(
                      Icons.refresh_rounded,
                      size: 20,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_loadingRecipes)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_recipesError != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _recipesError!,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              )
            else if (_suggestedRecipes != null && _suggestedRecipes!.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Nie znaleziono przepisów dla tych składników.',
                  style: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
                ),
              )
            else if (_suggestedRecipes != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_suggestedRecipes!
                      .any((r) =>
                          r.allIngredientsAvailable ||
                          r.matchedIngredients >= r.totalIngredients))
                    _RecipesRow(
                      label: 'Możesz zrobić teraz',
                      labelIcon: Icons.check_circle_rounded,
                      labelColor: const Color(0xFF2E7D32),
                      recipes: _suggestedRecipes!
                          .where((r) =>
                              r.allIngredientsAvailable ||
                              r.matchedIngredients >= r.totalIngredients)
                          .toList(),
                    ),
                  if (_suggestedRecipes!
                      .any((r) =>
                          !r.allIngredientsAvailable &&
                          r.matchedIngredients < r.totalIngredients))
                    _RecipesRow(
                      label: 'Brakuje kilku składników',
                      labelIcon: Icons.shopping_cart_outlined,
                      labelColor: AppColors.onSurfaceVariant,
                      recipes: _suggestedRecipes!
                          .where((r) =>
                              !r.allIngredientsAvailable &&
                              r.matchedIngredients < r.totalIngredients)
                          .toList(),
                    ),
                ],
              ),
            const SizedBox(height: 16),
            // ── Add ingredient ─────────────────────────────────────
            Text(
              'Brakuje czegoś?',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addController,
                    decoration: const InputDecoration(
                      hintText: 'Dodaj składnik...',
                    ),
                    onSubmitted: _addIngredient,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _addIngredient(_addController.text),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryContainer],
                      ),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Popular additions
            Text(
              'Popularne dodatki',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _popularAdditions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final item = _popularAdditions[index];
                  return IngredientFloatingPlate(
                    name: item['name'] as String,
                    icon: item['icon'] as IconData,
                    onTap: () => _addIngredient(item['name'] as String),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            // CTA button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryContainer],
                  ),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: ElevatedButton(
                  onPressed: _ingredients.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipesScreen(
                                ingredients: _ingredients,
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'ZNAJDŹ PRZEPISY',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.05 * 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipesRow extends StatelessWidget {
  final String label;
  final IconData labelIcon;
  final Color labelColor;
  final List<Recipe> recipes;

  const _RecipesRow({
    required this.label,
    required this.labelIcon,
    required this.labelColor,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(labelIcon, size: 16, color: labelColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recipes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => SizedBox(
              width: 150,
              child: RecipeCard(recipe: recipes[index]),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
