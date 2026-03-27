import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

class CoZjemApp extends StatelessWidget {
  const CoZjemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoZjem',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
