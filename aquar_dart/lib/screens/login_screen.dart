import 'package:flutter/material.dart';
import '../models/app_user.dart';
import 'admin_home.dart';
import 'customer_home.dart';
import 'delivery_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  UserRole role = UserRole.customer;

  @override void dispose() { emailController.dispose(); passwordController.dispose(); super.dispose(); }

  void login() {
    if (!_formKey.currentState!.validate()) return;
    final Widget destination = switch (role) {
      UserRole.customer => const CustomerHome(),
      UserRole.admin => const AdminHome(),
      UserRole.delivery => const DeliveryHome(),
    };
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => destination), (route) => false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Login')),
    body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 24),
      const Text('Welcome back', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6), Text('Log in to continue.', style: TextStyle(color: Colors.grey.shade600)),
      const SizedBox(height: 28),
      TextFormField(controller: emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Phone or email', prefixIcon: Icon(Icons.person_outline)), validator: (v) => v == null || v.trim().isEmpty ? 'Enter your phone number or email' : null),
      const SizedBox(height: 16),
      TextFormField(controller: passwordController, obscureText: obscurePassword, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton(onPressed: () => setState(() => obscurePassword = !obscurePassword), icon: Icon(obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined))), validator: (v) => v == null || v.isEmpty ? 'Enter your password' : null),
      const SizedBox(height: 20),
      const Text('Select your role', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      SegmentedButton<UserRole>(segments: const [ButtonSegment(value: UserRole.customer, label: Text('Customer')), ButtonSegment(value: UserRole.delivery, label: Text('Delivery')), ButtonSegment(value: UserRole.admin, label: Text('Admin'))], selected: {role}, onSelectionChanged: (s) => setState(() => role = s.first), showSelectedIcon: false),
      const SizedBox(height: 28), ElevatedButton(onPressed: login, child: const Text('Login')),
      const SizedBox(height: 12),
    ])))),
  );
}
