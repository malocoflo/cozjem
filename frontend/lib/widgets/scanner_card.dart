import 'dart:math' show pi;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ScannerCard extends StatelessWidget {
  final VoidCallback onScanTap;
  final VoidCallback onGalleryTap;
  final bool isLoading;

  const ScannerCard({
    super.key,
    required this.onScanTap,
    required this.onGalleryTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: AppColors.surfaceContainerHigh,
        image: const DecorationImage(
          image: AssetImage('assets/images/fridge_placeholder.jpg'),
          fit: BoxFit.cover,
          onError: _imageErrorHandler,
        ),
      ),
      child: Stack(
        children: [
          // Dark overlay for legibility
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x20000000),
                  Color(0x80000000),
                ],
              ),
            ),
          ),
          // Viewfinder corners
          Positioned.fill(
            child: CustomPaint(
              painter: _ViewfinderPainter(),
            ),
          ),
          // Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Camera button
                GestureDetector(
                  onTap: isLoading ? null : onScanTap,
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        transform: GradientRotation(135 * pi / 180),
                        colors: [
                          AppColors.primary,
                          AppColors.primaryContainer,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'ZESKANUJ LODÓWKĘ',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.05 * 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _imageErrorHandler(Object exception, StackTrace? stackTrace) {
  // Silently handle missing asset
}

class _ViewfinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 24.0;
    const padding = 24.0;
    const radius = 8.0;

    final corners = [
      // Top-left
      [
        Offset(padding, padding + cornerLength),
        Offset(padding, padding + radius),
        Offset(padding + radius, padding),
        Offset(padding + cornerLength, padding),
      ],
      // Top-right
      [
        Offset(size.width - padding - cornerLength, padding),
        Offset(size.width - padding - radius, padding),
        Offset(size.width - padding, padding + radius),
        Offset(size.width - padding, padding + cornerLength),
      ],
      // Bottom-left
      [
        Offset(padding, size.height - padding - cornerLength),
        Offset(padding, size.height - padding - radius),
        Offset(padding + radius, size.height - padding),
        Offset(padding + cornerLength, size.height - padding),
      ],
      // Bottom-right
      [
        Offset(size.width - padding, size.height - padding - cornerLength),
        Offset(size.width - padding, size.height - padding - radius),
        Offset(size.width - padding - radius, size.height - padding),
        Offset(size.width - padding - cornerLength, size.height - padding),
      ],
    ];

    for (final corner in corners) {
      final path = Path()
        ..moveTo(corner[0].dx, corner[0].dy)
        ..lineTo(corner[1].dx, corner[1].dy)
        ..quadraticBezierTo(
          corner[2].dx,
          corner[2].dy,
          corner[3].dx,
          corner[3].dy,
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
