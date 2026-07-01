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
  final bool isMobile;
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final void Function(GlobalKey) scrollToSection;
  final List<NavSectionConfig> sections;

  const StickyHeaderBar({
    super.key,
    required this.isMobile,
    required this.scrollController,
    required this.scaffoldKey,
    required this.scrollToSection,
    required this.sections,
  });

  @override
  Size get preferredSize => Size.fromHeight(isMobile ? 64 : 80);

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder updates the header layout dynamically without triggering broad page rebuilds
    return ListenableBuilder(
      listenable: scrollController,
      builder: (context, _) {
        final double offset = scrollController.hasClients ? scrollController.offset : 0.0;
        final bool isScrolled = offset > 20;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          height: preferredSize.height,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 40,
          ),
          decoration: BoxDecoration(
            color: isScrolled
                ? const Color(0xFF0B0C10).withValues(alpha: 0.95)
                : const Color(0xFF0B0C10),
            border: Border(
              bottom: BorderSide(
                color: isScrolled
                    ? const Color(0xFF1F2937).withValues(alpha: 0.4)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            boxShadow: isScrolled
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 12,
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
                _buildBrandingLogo(),
                if (!isMobile) _buildDesktopNav() else _buildMobileNavActions(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBrandingLogo() {
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
            fontSize: isMobile ? 22 : 26,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF45F3FF),
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopNav() {
    // Splits the last array entry out to act explicitly as the Call To Action button
    final menuItems = sections.take(sections.length - 1).toList();
    final ctaItem = sections.isNotEmpty ? sections.last : null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...menuItems.map((section) => _AnimatedNavButton(
              text: section.title.toUpperCase(),
              onPressed: () => scrollToSection(section.targetKey),
            )),
        if (ctaItem != null) ...[
          const SizedBox(width: 16),
          _buildCTAButton(ctaItem),
        ],
      ],
    );
  }

  Widget _buildCTAButton(NavSectionConfig ctaItem) {
    return ElevatedButton(
      onPressed: () => scrollToSection(ctaItem.targetKey),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF45F3FF),
        foregroundColor: const Color(0xFF0B0C10),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          fontSize: 13,
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
          iconSize: 22,
        ),
        IconButton(
          icon: const Icon(Icons.code_rounded),
          onPressed: () => GitHubService.launchProfile(),
          tooltip: 'GitHub Profile',
          color: const Color(0xFF9CA3AF),
          iconSize: 22,
        ),
        const SizedBox(width: 4),
        Container(
          height: 32,
          width: 1,
          color: const Color(0xFF1F2937),
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
          tooltip: 'Open Menu',
          color: Colors.white,
          iconSize: 26,
        ),
      ],
    );
  }
}

/// Layout-Stabilized Hover Navigation button with micro-shadow slide indicator
class _AnimatedNavButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const _AnimatedNavButton({
    required this.text,
    required this.onPressed,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      fontSize: 13,
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
                                  )
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
