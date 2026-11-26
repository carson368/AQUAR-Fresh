import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const AquaFreshApp());

class AquaFreshApp extends StatelessWidget {
  const AquaFreshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AQUA Fresh',
      theme: AppTheme.light,
      home: const WelcomeScreen(),
    );
  }
}
