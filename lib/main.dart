import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const KiuFreshApp());

class KiuFreshApp extends StatelessWidget {
  const KiuFreshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KIU Fresh',
      theme: AppTheme.light,
      home: const WelcomeScreen(),
    );
  }
}
