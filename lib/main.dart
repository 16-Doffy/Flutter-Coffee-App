import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const CafeShopApp());
}

class CafeShopApp extends StatelessWidget {
  const CafeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafe Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F0),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9A4F16),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
