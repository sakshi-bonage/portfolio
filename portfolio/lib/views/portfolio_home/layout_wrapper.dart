import 'package:flutter/material.dart';
import '../../widgets/responsivelayout.dart';
import 'screen_variants/mobile_viewport.dart';
import 'screen_variants/web_viewport.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E12),
      body: Stack(
        children: [
          // Primary Adaptive Screen Wrapper Stream
          ResponsiveLayout(
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
              achievementsKey: _achievementsKey, // Fully synchronized to match constructors
              projectsKey: _projectsKey,
              contactKey: _contactKey,
              scrollController: _scrollController,
            ),
          ),

          // Floating Persistent High-Fidelity Navigation Anchor Header
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: _buildFloatingNavbar(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF13151A).withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNavButton('Home', () => _scrollToSection(_heroKey)),
          const SizedBox(width: 20),
          _buildNavButton('About', () => _scrollToSection(_aboutKey)),
          const SizedBox(width: 20),
          _buildNavButton('Skills', () => _scrollToSection(_skillsKey)),
          const SizedBox(width: 20),
          _buildNavButton('Projects', () => _scrollToSection(_projectsKey)),
          const SizedBox(width: 20),
          _buildNavButton('Contact', () => _scrollToSection(_contactKey)),
        ],
      ),
    );
  }

  Widget _buildNavButton(String label, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(foregroundColor: Colors.white70),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
