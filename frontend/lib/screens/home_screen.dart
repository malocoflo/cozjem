import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/recipe.dart';
import '../services/camera_service.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glassmorphism_app_bar.dart';
import '../widgets/scanner_card.dart';
import '../widgets/recipe_card.dart';
import '../widgets/bottom_nav_bar.dart';
import 'ingredients_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CameraService _cameraService = CameraService();
  final ApiService _apiService = ApiService();
  int _currentNavIndex = 0;
  bool _isScanning = false;
  String? _errorMessage;

  // Placeholder quick recipes
  final List<Recipe> _quickRecipes = [
    const Recipe(
      id: '1',
      title: 'Zielona Miska Mocy',
      description: 'Pożywna miska pełna zielonych warzyw',
      durationMinutes: 15,
      imageUrl: '',
      matchedIngredients: 3,
      totalIngredients: 5,
      tags: ['#zdrowe', '#fit'],
    ),
    const Recipe(
      id: '2',
      title: 'Pizza Margherita Verace',
      description: 'Klasyczna włoska pizza na cienkim cieście',
      durationMinutes: 25,
      imageUrl: '',
      matchedIngredients: 2,
      totalIngredients: 6,
      isBestseller: true,
    ),
    const Recipe(
      id: '3',
      title: 'Sałatka z Łososiem',
      description: 'Lekka sałatka z świeżym łososiem',
      durationMinutes: 20,
      imageUrl: '',
      matchedIngredients: 4,
      totalIngredients: 4,
      isReady: true,
    ),
  ];

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  Future<void> _handleScan() async {
    setState(() {
      _isScanning = true;
      _errorMessage = null;
    });

    try {
      File? imageFile;

      // Try camera first, fall back to gallery if camera fails
      try {
        await _cameraService.initialize();
        imageFile = await _cameraService.takePicture();
      } catch (e) {
        // If camera fails, try gallery
        imageFile = await _cameraService.pickFromGallery();
      }

      if (imageFile == null) {
        setState(() => _isScanning = false);
        return;
      }

      final ingredients = await _apiService.analyzeFridge(imageFile);

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => IngredientsScreen(
              ingredients: ingredients,
              capturedImage: imageFile,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _handleGallery() async {
    setState(() {
      _isScanning = true;
      _errorMessage = null;
    });

    try {
      final imageFile = await _cameraService.pickFromGallery();
      if (imageFile == null) {
        setState(() => _isScanning = false);
        return;
      }

      final ingredients = await _apiService.analyzeFridge(imageFile);

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => IngredientsScreen(
              ingredients: ingredients,
              capturedImage: imageFile,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: GlassmorphismAppBar(
        onMenuTap: () {
          // Drawer not yet implemented — no-op
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kToolbarHeight + 20),
            // Hero headline
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Co dziś',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'gotujemy?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                      color: AppColors.primary,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Scanner card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ScannerCard(
                onScanTap: _handleScan,
                onGalleryTap: _handleGallery,
                isLoading: _isScanning,
              ),
            ),
            const SizedBox(height: 12),
            // Gallery button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: _isScanning ? null : _handleGallery,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Wybierz z galerii'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: const StadiumBorder(),
                  side: const BorderSide(
                    color: AppColors.outlineVariant,
                  ),
                  foregroundColor: AppColors.onSurface,
                ),
              ),
            ),
            // Error message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.error,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 32),
            // Quick recipes section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Szybkie przepisy',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _quickRecipes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => SizedBox(
                  width: 180,
                  child: RecipeCard(recipe: _quickRecipes[index]),
                ),
              ),
            ),
            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: CoZjemBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleScan,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryContainer],
            ),
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
