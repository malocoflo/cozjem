import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterChipBar extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const FilterChipBar({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isActive = filter == selectedFilter;
          return GestureDetector(
            onTap: () => onFilterSelected(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.secondaryContainer
                    : AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                filter,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? AppColors.onSecondaryContainer
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
