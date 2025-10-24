import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String status = "";

  Future<void> signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() => status = "✅ Account Created!");
    } catch (e) {
      setState(() => status = "❌ $e");
    }
  }

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() => status = "✅ Logged In!");
    } catch (e) {
      setState(() => status = "❌ $e");
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    setState(() => status = "👋 Logged Out!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Auth Demo")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: signUp, child: const Text("Sign Up")),
            ElevatedButton(onPressed: login, child: const Text("Login")),
            ElevatedButton(onPressed: logout, child: const Text("Logout")),
            const SizedBox(height: 20),
            Text(status, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
