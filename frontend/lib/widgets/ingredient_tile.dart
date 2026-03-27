import 'package:flutter/material.dart';
import '../models/ingredient.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback? onRemove;

  const IngredientTile({
    super.key,
    required this.ingredient,
    this.onRemove,
  });

  IconData _iconForCategory(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('nabiał') || lower.contains('jaj')) {
      return Icons.egg_outlined;
    } else if (lower.contains('warzywa') || lower.contains('owoc')) {
      return Icons.nutrition_outlined;
    } else if (lower.contains('napój') || lower.contains('mleko')) {
      return Icons.water_drop_outlined;
    } else if (lower.contains('mięso') || lower.contains('ryba')) {
      return Icons.set_meal_outlined;
    } else {
      return Icons.restaurant_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _iconForCategory(ingredient.category),
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  ingredient.category,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (onRemove != null)
            GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
