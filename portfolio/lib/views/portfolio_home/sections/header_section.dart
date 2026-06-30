import 'package:flutter/material.dart';
import '../../../services/git_service.dart';
import '../../../services/linkedin_service.dart';

class StickyHeaderBar extends StatefulWidget {
  final bool isMobile;
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey aboutKey;
  final GlobalKey skillsKey;
  final GlobalKey projectsKey;
  final GlobalKey achievementsKey;
  final GlobalKey contactKey;
  final void Function(GlobalKey) scrollToSection;

  const StickyHeaderBar({
    super.key,
    required this.isMobile,
    required this.scrollController,
    required this.scaffoldKey,
    required this.aboutKey,
    required this.skillsKey,
    required this.projectsKey,
    required this.achievementsKey,
    required this.contactKey,
    required this.scrollToSection,
  });

  @override
  State<StickyHeaderBar> createState() => _StickyHeaderBarState();
}

class _StickyHeaderBarState extends State<StickyHeaderBar> {
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    // High-performance scroll listener framework integration
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (widget.scrollController.hasClients) {
      if (widget.scrollController.offset > 20 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (widget.scrollController.offset <= 20 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: widget.isMobile ? 24 : 40,
        vertical: _isScrolled
            ? 12
            : 20, // Clean background compression on scroll
      ),
      decoration: BoxDecoration(
        color: _isScrolled
            ? const Color(0xFF0B0C10).withValues(alpha: 0.92)
            : const Color(0xFF0B0C10),
        border: Border(
          bottom: BorderSide(
            color: _isScrolled
                ? const Color(0xFF1F2937).withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1,
          ),
        ),
        boxShadow: _isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo Branding Title Block
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => widget.scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                ),
                child: Text(
                  '<> SRB',
                  style: TextStyle(
                    fontSize: widget.isMobile ? 22 : 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF45F3FF),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),

            // Responsive Content Filter Split
            if (!widget.isMobile)
              Row(
                children: [
                  _AnimatedNavButton(
                    text: 'ABOUT',
                    onPressed: () => widget.scrollToSection(widget.aboutKey),
                  ),
                  _AnimatedNavButton(
                    text: 'SKILLS',
                    onPressed: () => widget.scrollToSection(widget.skillsKey),
                  ),
                  _AnimatedNavButton(
                    text: 'PROJECTS',
                    onPressed: () => widget.scrollToSection(widget.projectsKey),
                  ),
                  _AnimatedNavButton(
                    text: 'ACHIEVEMENTS',
                    onPressed: () =>
                        widget.scrollToSection(widget.achievementsKey),
                  ),
                  const SizedBox(width: 16),

                  // Primary Premium Action Button
                  ElevatedButton(
                    onPressed: () => widget.scrollToSection(widget.contactKey),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF45F3FF),
                      foregroundColor: const Color(0xFF0B0C10),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      "CONTACT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              )
            else
              // Compact Mobile Layout Action Engine
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.link_rounded),
                    onPressed: () => LinkedInService.launchProfile(),
                    tooltip: 'LinkedIn',
                    color: const Color(0xFF9CA3AF),
                    iconSize: 20,
                  ),
                  IconButton(
                    icon: const Icon(Icons.code_rounded),
                    onPressed: () => GitHubService.launchProfile(),
                    tooltip: 'GitHub',
                    color: const Color(0xFF9CA3AF),
                    iconSize: 20,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () =>
                        widget.scaffoldKey.currentState?.openDrawer(),
                    color: Colors.white,
                    iconSize: 24,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// Private Extracted Micro-Widget processing standalone button states dynamically
class _AnimatedNavButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const _AnimatedNavButton({required this.text, required this.onPressed});

  @override
  State<_AnimatedNavButton> createState() => _AnimatedNavButtonState();
}

class _AnimatedNavButtonState extends State<_AnimatedNavButton> {
  final ValueNotifier<bool> _isHoveredNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isHoveredNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isHoveredNotifier.value = true,
      onExit: (_) => _isHoveredNotifier.value = false,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ValueListenableBuilder<bool>(
            valueListenable: _isHoveredNotifier,
            builder: (context, isHovered, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text Fade Element Layer
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: isHovered
                          ? const Color(0xFF45F3FF)
                          : const Color(0xFF9CA3AF),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                    child: Text(widget.text),
                  ),
                  const SizedBox(height: 4),

                  // Underlined Animation Slide Frame
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    height: 2,
                    width: isHovered ? 24 : 0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF45F3FF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
