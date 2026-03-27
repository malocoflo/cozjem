import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../theme/app_theme.dart';
import '../widgets/filter_chip_bar.dart';
import '../widgets/recipe_card.dart';
import '../widgets/bottom_nav_bar.dart';

class RecipesScreen extends StatefulWidget {
  final List<Ingredient> ingredients;

  const RecipesScreen({
    super.key,
    required this.ingredients,
  });

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  String _selectedFilter = 'Wszystkie';
  int _currentNavIndex = 1;

  final List<String> _filters = [
    'Wszystkie',
    'Szybkie (do 20 min)',
    'Wegetariańskie',
    'Wysokobiałkowe',
  ];

  // Mock recipes based on ingredients
  late final List<Recipe> _allRecipes;
  final Set<String> _bookmarked = {};

  @override
  void initState() {
    super.initState();
    _allRecipes = _generateMockRecipes();
  }

  List<Recipe> _generateMockRecipes() {
    final n = widget.ingredients.length;
    return [
      Recipe(
        id: '1',
        title: 'Zielona Miska Mocy',
        description: 'Odżywcza miska pełna składników z Twojej lodówki',
        durationMinutes: 15,
        imageUrl: '',
        matchedIngredients: n.clamp(1, 3),
        totalIngredients: 5,
        tags: ['#wege', '#fit'],
      ),
      Recipe(
        id: '2',
        title: 'Pizza Margherita Verace',
        description: 'Klasyczna włoska pizza z prostymi składnikami',
        durationMinutes: 25,
        imageUrl: '',
        matchedIngredients: n.clamp(1, 4),
        totalIngredients: 6,
        isBestseller: true,
      ),
      Recipe(
        id: '3',
        title: 'Sałatka z Łososiem',
        description: 'Lekka i zdrowa sałatka idealna na lunch',
        durationMinutes: 20,
        imageUrl: '',
        matchedIngredients: n.clamp(2, 5),
        totalIngredients: n.clamp(2, 5),
        isReady: true,
      ),
      Recipe(
        id: '4',
        title: 'Tęczowe Poké Bowl',
        description: 'Kolorowa miska inspirowana kuchnią hawajską',
        durationMinutes: 12,
        imageUrl: '',
        matchedIngredients: n.clamp(1, 3),
        totalIngredients: 7,
        tags: ['#wege', '#fit'],
      ),
    ];
  }

  List<Recipe> get _filteredRecipes {
    switch (_selectedFilter) {
      case 'Szybkie (do 20 min)':
        return _allRecipes.where((r) => r.durationMinutes <= 20).toList();
      case 'Wegetariańskie':
        return _allRecipes
            .where((r) => r.tags.any((t) => t.contains('wege')))
            .toList();
      case 'Wysokobiałkowe':
        return _allRecipes.where((r) => r.tags.contains('#highprotein')).toList();
      default:
        return _allRecipes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipes = _filteredRecipes;

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wyniki wyszukiwania',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.05 * 12,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Inspiracje dla Ciebie',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Na podstawie ${widget.ingredients.length} składnik${widget.ingredients.length == 1 ? "a" : "ów"}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Filter chips
          FilterChipBar(
            filters: _filters,
            selectedFilter: _selectedFilter,
            onFilterSelected: (f) => setState(() => _selectedFilter = f),
          ),
          const SizedBox(height: 16),
          // Recipe grid
          Expanded(
            child: recipes.isEmpty
                ? _EmptyState(
                    onLoadMore: () {
                      setState(() => _selectedFilter = 'Wszystkie');
                    },
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        isBookmarked: _bookmarked.contains(recipe.id),
                        onBookmarkToggle: (val) {
                          setState(() {
                            if (val) {
                              _bookmarked.add(recipe.id);
                            } else {
                              _bookmarked.remove(recipe.id);
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CoZjemBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onLoadMore;
  const _EmptyState({required this.onLoadMore});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Szukasz czegoś innego?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nie znaleziono przepisów dla wybranego filtra.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: onLoadMore,
            style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(),
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
            ),
            child: const Text('Wczytaj więcej przepisów'),
          ),
        ],
      ),
    );
  }
}
