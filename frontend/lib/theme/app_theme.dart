import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF006E1C);
  static const primaryContainer = Color(0xFF4CAF50);
  static const secondary = Color(0xFF8B5000);
  static const secondaryContainer = Color(0xFFFF9800);
  static const surface = Color(0xFFF8FAF8);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF2F4F2);
  static const surfaceContainer = Color(0xFFECEEEC);
  static const surfaceContainerHigh = Color(0xFFE6E9E7);
  static const surfaceContainerHighest = Color(0xFFE1E3E1);
  static const onSurface = Color(0xFF191C1B);
  static const onSurfaceVariant = Color(0xFF3F4A3C);
  static const outlineVariant = Color(0xFFBECAB9);
  static const error = Color(0xFFBA1A1A);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSecondary = Color(0xFFFFFFFF);
  static const onSecondaryContainer = Color(0xFF653900);
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          primaryContainer: AppColors.primaryContainer,
          onPrimaryContainer: Color(0xFF003C0B),
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          secondaryContainer: AppColors.secondaryContainer,
          onSecondaryContainer: AppColors.onSecondaryContainer,
          tertiary: Color(0xFF1B6D24),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFF5DAC5B),
          onTertiaryContainer: Color(0xFF003C0A),
          error: AppColors.error,
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFFDAD6),
          onErrorContainer: Color(0xFF93000A),
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          surfaceContainerHighest: AppColors.surfaceContainerHighest,
          surfaceContainerHigh: AppColors.surfaceContainerHigh,
          surfaceContainer: AppColors.surfaceContainer,
          surfaceContainerLow: AppColors.surfaceContainerLow,
          surfaceContainerLowest: AppColors.surfaceContainerLowest,
          onSurfaceVariant: AppColors.onSurfaceVariant,
          outline: Color(0xFF6F7A6B),
          outlineVariant: AppColors.outlineVariant,
          inverseSurface: Color(0xFF2E3130),
          onInverseSurface: Color(0xFFEFF1EF),
          inversePrimary: Color(0xFF78DC77),
          scrim: Color(0xFF000000),
          shadow: Color(0xFF000000),
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.plusJakartaSans(
            fontSize: 56,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.02 * 56,
            color: AppColors.onSurface,
          ),
          displayMedium: GoogleFonts.plusJakartaSans(
            fontSize: 45,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.02 * 45,
            color: AppColors.onSurface,
          ),
          displaySmall: GoogleFonts.plusJakartaSans(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.02 * 36,
            color: AppColors.onSurface,
          ),
          headlineLarge: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
          headlineMedium: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
          headlineSmall: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
          titleLarge: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
          titleSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.6,
            color: AppColors.onSurface,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.6,
            color: AppColors.onSurface,
          ),
          bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurfaceVariant,
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05 * 14,
            color: AppColors.onSurface,
          ),
          labelMedium: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05 * 12,
            color: AppColors.onSurface,
          ),
          labelSmall: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.05 * 11,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        scaffoldBackgroundColor: AppColors.surface,
        cardTheme: CardTheme(
          color: AppColors.surfaceContainerLowest,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
        chipTheme: ChipThemeData(
          shape: const StadiumBorder(),
          backgroundColor: AppColors.surfaceContainerHigh,
          selectedColor: AppColors.secondaryContainer,
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceContainer,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      );
}
