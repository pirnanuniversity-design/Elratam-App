import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 5 second splash
    Timer(const Duration(seconds: 5), () {
      // navigate by name to avoid importing main.dart (prevents circular import)
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 180,
          height: 180,
        ),
      ),
    );
  }
}

class ElratamApp extends StatelessWidget {
  const ElratamApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with your actual app widget tree
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elratam App'),
      ),
      body: const Center(
        child: Text('Welcome to Elratam App!'),
      ),
    );
  }
}
