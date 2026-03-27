import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class IngredientFloatingPlate extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback? onTap;

  const IngredientFloatingPlate({
    super.key,
    required this.name,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.onSurface.withOpacity(0.06),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
