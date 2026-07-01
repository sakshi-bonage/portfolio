import 'package:flutter/material.dart';

// Precise relative path to your multi-viewport architecture container layout shell
import 'views/portfolio_home/layout_wrapper.dart';

void main() {
  runApp(const SakshiPortfolioApp());
}

class SakshiPortfolioApp extends StatelessWidget {
  const SakshiPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sakshi Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0E12),
        useMaterial3: true,
      ),
      // Safely instantiates and calls your layout wrapper architecture module
      home: const LayoutWrapper(),
    );
  }
}
