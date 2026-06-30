import 'package:flutter/material.dart';
import '../sections/hero_section.dart';

class WebViewport extends StatelessWidget {
  const WebViewport({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildHeroSection(false),

          // AboutSection(),
          // SkillsSection(),
          // ExperienceSection(),
          // ProjectsSection(),
          // ContactSection(),
          // FooterSection(),
        ],
      ),
    );
  }
}