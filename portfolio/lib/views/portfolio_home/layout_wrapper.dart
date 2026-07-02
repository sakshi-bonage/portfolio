import 'package:flutter/material.dart';
import '../../widgets/responsivelayout.dart';
import 'screen_variants/mobile_viewport.dart';
import 'screen_variants/web_viewport.dart';
import 'sections/header_section.dart';

class LayoutWrapper extends StatefulWidget {
  const LayoutWrapper({super.key});

  @override
  State<LayoutWrapper> createState() => _LayoutWrapperState();
}

class _LayoutWrapperState extends State<LayoutWrapper> {
  // Master hardware layout viewport scrolling track controller
  final ScrollController _scrollController = ScrollController();

  // Distinct global layout keys ensuring precision alignment targets across devices
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _achievementsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic, // Zero-jank fluid frame animation curve
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final sections = [
      NavSectionConfig(title: 'Home', targetKey: _heroKey),
      NavSectionConfig(title: 'About', targetKey: _aboutKey),
      NavSectionConfig(title: 'Skills', targetKey: _skillsKey),
      NavSectionConfig(title: 'Projects', targetKey: _projectsKey),
      NavSectionConfig(title: 'Contact', targetKey: _contactKey),
    ];

    return Scaffold(
      key: _scaffoldKey,

      drawer: MobileDrawer(
        sections: sections,
        scrollToSection: _scrollToSection,
      ),

      backgroundColor: const Color(0xFF0D0E12),
      appBar: StickyHeaderBar(
        scrollController: _scrollController,
        scaffoldKey: _scaffoldKey,
        scrollToSection: _scrollToSection,
        sections: sections,
      ),

      body: ResponsiveLayout(
        mobile: MobileViewport(
          heroKey: _heroKey,
          aboutKey: _aboutKey,
          skillsKey: _skillsKey,
          achievementsKey: _achievementsKey,
          projectsKey: _projectsKey,
          contactKey: _contactKey,
          scrollController: _scrollController,
        ),
        desktop: WebViewport(
          heroKey: _heroKey,
          aboutKey: _aboutKey,
          skillsKey: _skillsKey,
          achievementsKey: _achievementsKey,
          projectsKey: _projectsKey,
          contactKey: _contactKey,
          scrollController: _scrollController,
        ),
      ),
    );
  }
}
