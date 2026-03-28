import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassmorphismAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onAvatarTap;

  const GlassmorphismAppBar({
    super.key,
    this.onMenuTap,
    this.onAvatarTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: AppColors.surface.withOpacity(0.7),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: kToolbarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: onMenuTap,
                      icon: const Icon(Icons.menu_rounded),
                      color: AppColors.onSurface,
                    ),
                    const Spacer(),
                    Text(
                      'CoZjem',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onAvatarTap,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.surfaceContainerHigh,
                        child: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
