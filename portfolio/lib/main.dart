import 'package:flutter/material.dart';
import 'views/portfolio_home/layout_wrapper.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sakshi Bonage',
      home: const Scaffold(
        body: LayoutWrapper(),
      ),
    );
  }
}