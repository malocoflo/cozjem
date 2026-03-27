import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;
  final bool isBookmarked;
  final ValueChanged<bool>? onBookmarkToggle;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.isBookmarked = false,
    this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: AppColors.surfaceContainerLowest,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: AppColors.surfaceContainerHigh,
                    child: const Center(
                      child: Icon(
                        Icons.restaurant_menu_rounded,
                        size: 48,
                        color: AppColors.outlineVariant,
                      ),
                    ),
                  ),
                  // Timer badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _TimerBadge(minutes: recipe.durationMinutes),
                  ),
                  // Ingredient match badge
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: _IngredientMatchBadge(
                      matched: recipe.matchedIngredients,
                      total: recipe.totalIngredients,
                    ),
                  ),
                  // Bookmark
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => onBookmarkToggle?.call(!isBookmarked),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          size: 18,
                          color: isBookmarked
                              ? AppColors.secondary
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  // Special badges
                  if (recipe.isBestseller)
                    Positioned(
                      top: 12,
                      right: 40,
                      child: _SpecialBadge(
                        text: 'Bestseller',
                        color: AppColors.secondary,
                      ),
                    ),
                  if (recipe.isReady)
                    Positioned(
                      top: 12,
                      right: 8,
                      child: _SpecialBadge(
                        text: 'GOTOWE',
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),
            // Text content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (recipe.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      recipe.description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Zobacz przepis',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerBadge extends StatelessWidget {
  final int minutes;
  const _TimerBadge({required this.minutes});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: AppColors.surface.withOpacity(0.7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_outlined, size: 12, color: AppColors.onSurface),
              const SizedBox(width: 4),
              Text(
                '$minutes min',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IngredientMatchBadge extends StatelessWidget {
  final int matched;
  final int total;
  const _IngredientMatchBadge({required this.matched, required this.total});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: AppColors.surface.withOpacity(0.7),
          child: Text(
            'Masz $matched z $total składników',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _SpecialBadge extends StatelessWidget {
  final String text;
  final Color color;
  const _SpecialBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
