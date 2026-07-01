import 'package:flutter/material.dart';

import '../sections/hero_section.dart';
import '../sections/about_section.dart';
import '../sections/skills_section.dart';
import '../sections/achievements_section.dart'; 
import '../sections/projects_section.dart';
import '../sections/contact_section.dart';
import '../sections/experience_section.dart';
import '../sections/footer_section.dart';

class WebViewport extends StatelessWidget {
  final GlobalKey heroKey;
  final GlobalKey aboutKey;
  final GlobalKey skillsKey;
  final GlobalKey achievementsKey; 
  final GlobalKey projectsKey;
  final GlobalKey contactKey;
  final ScrollController scrollController;

  const WebViewport({
    required this.heroKey,
    required this.aboutKey,
    required this.skillsKey,
    required this.achievementsKey, 
    required this.projectsKey,
    required this.contactKey,
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          HeroSection(sectionKey: heroKey),
          AboutSection(sectionKey: aboutKey),
          SkillsSection(sectionKey: skillsKey),
          ExperienceSection(sectionKey: GlobalKey()),
          AchievementsSection(sectionKey: achievementsKey), 
          ProjectsSection(sectionKey: projectsKey, isMobile: false),
          ContactSection(sectionKey: contactKey),
          
          // Appended desktop-optimized footer layout structure cleanly
          FooterSection(isMobile: false, scrollController: scrollController),
        ],
      ),
    );
  }
}
