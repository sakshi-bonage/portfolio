import 'package:flutter/material.dart';
import '../sections/hero_section.dart';
import '../sections/about_section.dart';
import '../sections/skills_section.dart';
import '../sections/projects_section.dart';
import '../sections/contact_section.dart';
import '../sections/achievements_section.dart';

class WebViewport extends StatelessWidget {
  const WebViewport({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildHeroSection(false),
          AboutSection(sectionKey: GlobalKey()),
          skillsSection(false, key: GlobalKey()),
          achievementsSection(false, key: GlobalKey()),
          projectsSection(false, key: GlobalKey()),
          ContactSection(isMobile: false, sectionKey: GlobalKey()),
        ],
      ),
    );
  }
}
