import 'package:flutter/material.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
      const Spacer(),
      Container(width: 96, height: 96, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle), child: const Icon(Icons.water_drop_rounded, size: 52)),
      const SizedBox(height: 24),
      const Text('KIU FRESH', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: 1)),
      const SizedBox(height: 8),
      Text('Your Water Refilling Station', style: TextStyle(fontSize: 17, color: Colors.grey.shade700)),
      const SizedBox(height: 16),
      Text('Order clean water, follow your delivery, and stay refreshed.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
      const Spacer(),
      ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())), child: const Text('Get Started')),
      const SizedBox(height: 12),
      Text('MVP · Local demo data', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
    ]))),
  );
}
