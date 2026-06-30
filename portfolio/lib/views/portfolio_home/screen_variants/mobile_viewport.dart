import 'package:flutter/material.dart';
import '../sections/hero_section.dart';
import '../sections/about_section.dart';
import '../sections/skills_section.dart';
import '../sections/projects_section.dart';
import '../sections/contact_section.dart';
import '../sections/achivements_section.dart';
class MobileViewport extends StatelessWidget {
  const MobileViewport({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
  child: Column(
    children: [
      buildHeroSection(false),

      AboutSection(),
      skillsSection(),
      projectsSection(),
      ContactSection(),
      achievementsSection(),
    ]
  ),
    );
  }
}