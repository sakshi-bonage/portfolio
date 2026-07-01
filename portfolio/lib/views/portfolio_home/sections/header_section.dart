import 'package:flutter/material.dart';
import '../../../services/git_service.dart';
import '../../../services/linkedin_service.dart';

/// Configuration data structure to simplify key passing logic across nav items
class NavSectionConfig {
  final String title;
  final GlobalKey targetKey;

  const NavSectionConfig({required this.title, required this.targetKey});
}

class StickyHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final void Function(GlobalKey targetKey) scrollToSection;
  final List<NavSectionConfig> sections;

  const StickyHeaderBar({
    super.key,
    required this.scrollController,
    required this.scaffoldKey,
    required this.scrollToSection,
    required this.sections,
  });

  /// Dynamic size reporting based on device layout thresholds
  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    
    // Core Layout Breakpoints
    final bool isMobile = screenWidth < 640;
    final bool isTablet = screenWidth >= 640 && screenWidth < 1024;

    return _StickyHeaderBackground(
      scrollController: scrollController,
      height: isMobile ? 64.0 : preferredSize.height,
      horizontalPadding: isMobile ? 16.0 : (isTablet ? 32.0 : 48.0),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBrandingLogo(isMobile),
            if (isMobile)
              _buildMobileNavActions()
            else
              _buildResponsiveDesktopNav(isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandingLogo(bool isMobile) {
    return InkWell(
      onTap: () => scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      ),
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          '<> SRB',
          style: TextStyle(
            fontSize: isMobile ? 20.0 : 24.0,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF45F3FF),
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveDesktopNav(bool isTablet) {
    if (sections.isEmpty) return const SizedBox.shrink();
    
    // Explicitly parse CTA from regular text items
    final menuItems = sections.take(sections.length - 1);
    final ctaItem = sections.last;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...menuItems.map((section) => _AnimatedNavButton(
              text: section.title.toUpperCase(),
              onPressed: () => scrollToSection(section.targetKey),
              isTablet: isTablet,
            )),
        SizedBox(width: isTablet ? 12.0 : 20.0),
        _buildCTAButton(ctaItem, isTablet),
      ],
    );
  }

  Widget _buildCTAButton(NavSectionConfig ctaItem, bool isTablet) {
    return ElevatedButton(
      onPressed: () => scrollToSection(ctaItem.targetKey),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF45F3FF),
        foregroundColor: const Color(0xFF0B0C10),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16.0 : 24.0, 
          vertical: isTablet ? 12.0 : 16.0,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.hovered)) {
              return const Color(0xFF00E5FF).withValues(alpha: 0.2);
            }
            return null;
          },
        ),
      ),
      child: Text(
        ctaItem.title.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          fontSize: isTablet ? 12.0 : 13.0,
        ),
      ),
    );
  }

  Widget _buildMobileNavActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.link_rounded),
          onPressed: () => LinkedInService.launchProfile(),
          tooltip: 'LinkedIn Profile',
          color: const Color(0xFF9CA3AF),
          iconSize: 20,
        ),
        IconButton(
          icon: const Icon(Icons.code_rounded),
          onPressed: () => GitHubService.launchProfile(),
          tooltip: 'GitHub Profile',
          color: const Color(0xFF9CA3AF),
          iconSize: 20,
        ),
        const SizedBox(width: 2),
        Container(
          height: 24,
          width: 1,
          color: const Color(0xFF1F2937),
        ),
        const SizedBox(width: 2),
        IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
          tooltip: 'Open Menu',
          color: Colors.white,
          iconSize: 24,
        ),
      ],
    );
  }
}

/// Extracted background shell to minimize rebuild scopes during active scroll events
class _StickyHeaderBackground extends StatelessWidget {
  final ScrollController scrollController;
  final double height;
  final double horizontalPadding;
  final Widget child;

  const _StickyHeaderBackground({
    required this.scrollController,
    required this.height,
    required this.horizontalPadding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: scrollController,
      builder: (context, _) {
        final double offset = scrollController.hasClients ? scrollController.offset : 0.0;
        final bool isScrolled = offset > 20.0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          height: height,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: BoxDecoration(
            color: isScrolled
                ? const Color(0xFF0B0C10).withValues(alpha: 0.95)
                : const Color(0xFF0B0C10),
            border: Border(
              bottom: BorderSide(
                color: isScrolled
                    ? const Color(0xFF1F2937).withValues(alpha: 0.4)
                    : Colors.transparent,
                width: 1.0,
              ),
            ),
            boxShadow: isScrolled
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 12.0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: child,
        );
      },
    );
  }
}

/// Layout-Stabilized Hover Navigation button with micro-shadow slide indicator
class _AnimatedNavButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isTablet;

  const _AnimatedNavButton({
    required this.text,
    required this.onPressed,
    required this.isTablet,
  });

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
    const Duration animationDuration = Duration(milliseconds: 200);
    const Curve animationCurve = Curves.easeOutCubic;

    return MouseRegion(
      onEnter: (_) => _isHoveredNotifier.value = true,
      onExit: (_) => _isHoveredNotifier.value = false,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isTablet ? 10.0 : 16.0, 
            vertical: 8.0,
          ),
          child: ValueListenableBuilder<bool>(
            valueListenable: _isHoveredNotifier,
            builder: (context, isHovered, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: animationDuration,
                    curve: animationCurve,
                    style: TextStyle(
                      color: isHovered ? const Color(0xFF45F3FF) : const Color(0xFF9CA3AF),
                      fontSize: widget.isTablet ? 12.0 : 13.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                    child: Text(widget.text),
                  ),
                  const SizedBox(height: 6),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(height: 2, width: 24), // Layout structural baseline
                      AnimatedContainer(
                        duration: animationDuration,
                        curve: animationCurve,
                        height: 2,
                        width: isHovered ? 24 : 0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF45F3FF),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: isHovered
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF45F3FF).withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : [],
                        ),
                      ),
                    ],
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
