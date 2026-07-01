import 'package:flutter/material.dart';

import '../sections/hero_section.dart';
import '../sections/about_section.dart';
import '../sections/skills_section.dart';
import '../sections/achievements_section.dart';
import '../sections/projects_section.dart';
import '../sections/contact_section.dart';
import '../sections/footer_section.dart'; // Added missing footer section reference import

class MobileViewport extends StatelessWidget {
  final GlobalKey heroKey;
  final GlobalKey aboutKey;
  final GlobalKey skillsKey;
  final GlobalKey achievementsKey;
  final GlobalKey projectsKey;
  final GlobalKey contactKey;
  final ScrollController scrollController;

  const MobileViewport({
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
          AchievementsSection(sectionKey: achievementsKey),
          ProjectsSection(sectionKey: projectsKey, isMobile: true),
          ContactSection(sectionKey: contactKey),
          
          // Appended mobile-optimized vertical stack footer structure cleanly
          FooterSection(isMobile: true, scrollController: scrollController),
        ],
      ),
    );
  }
}
