import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../services/git_service.dart';
import '../../../services/linkedin_service.dart';

class StickyHeaderBar extends StatefulWidget {
  final bool isMobile;
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey heroKey;
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
    required this.heroKey,
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
  final ValueNotifier<String> _activeSection = ValueNotifier<String>('HOME');
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollObserver);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollObserver);
    _activeSection.dispose();
    super.dispose();
  }

  // Smart section observer to track user scrolling positions in real-time
  void _scrollObserver() {
    if (!widget.scrollController.hasClients) return;

    final offset = widget.scrollController.offset;

    if (offset > 30 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (offset <= 30 && _isScrolled) {
      setState(() => _isScrolled = false);
    }

    // Dynamic section highlights based on average vertical pixel distributions
    if (offset < 500) {
      _activeSection.value = 'HOME';
    } else if (offset >= 500 && offset < 1200) {
      _activeSection.value = 'ABOUT';
    } else if (offset >= 1200 && offset < 2000) {
      _activeSection.value = 'SKILLS';
    } else if (offset >= 2000 && offset < 3200) {
      _activeSection.value = 'PROJECTS';
    } else if (offset >= 3200) {
      _activeSection.value = 'MILESTONES';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: widget.isMobile ? 24 : 60,
        vertical: _isScrolled ? 14 : 24,
      ),
      decoration: BoxDecoration(
        // High-end cyber glassmorphic tint profile
        color: _isScrolled
            ? const Color(0xFF0D0E12).withOpacity(0.70)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: _isScrolled
                ? const Color(0xFF45F3FF).withOpacity(0.12)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
      ),
      // Glassmorphic background frosting pipeline filter
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _isScrolled ? 16 : 0,
            sigmaY: _isScrolled ? 16 : 0,
          ),
          child: SafeArea(
            bottom: false,
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLogoBranding(),
                if (!widget.isMobile)
                  _buildDesktopNavigationHub()
                else
                  _buildMobileQuickActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoBranding() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.scrollToSection(widget.heroKey),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF45F3FF), Color(0xFF00B4D8)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'SRB',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w900, //  Success: Thickest production weight
                  color: Color(0xFF0D0E12),
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'PORTFOLIO',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopNavigationHub() {
    return ValueListenableBuilder<String>(
      valueListenable: _activeSection,
      builder: (context, currentTab, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TabAnchorLink(
              label: 'HOME',
              isActive: currentTab == 'HOME',
              onTap: () => widget.scrollToSection(widget.heroKey),
            ),
            _TabAnchorLink(
              label: 'ABOUT',
              isActive: currentTab == 'ABOUT',
              onTap: () => widget.scrollToSection(widget.aboutKey),
            ),
            _TabAnchorLink(
              label: 'SKILLS',
              isActive: currentTab == 'SKILLS',
              onTap: () => widget.scrollToSection(widget.skillsKey),
            ),
            _TabAnchorLink(
              label: 'PROJECTS',
              isActive: currentTab == 'PROJECTS',
              onTap: () => widget.scrollToSection(widget.projectsKey),
            ),
            _TabAnchorLink(
              label: 'MILESTONES',
              isActive: currentTab == 'MILESTONES',
              onTap: () => widget.scrollToSection(widget.achievementsKey),
            ),
            const SizedBox(width: 24),
            _buildContactCTA(),
          ],
        );
      },
    );
  }

  Widget _buildContactCTA() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.scrollToSection(widget.contactKey),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF13151A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF45F3FF).withOpacity(0.3),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF45F3FF).withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'HIRE ME',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF45F3FF),
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.bolt, size: 14, color: Color(0xFF45F3FF)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileQuickActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMobileCircleIcon(
          Icons.link_rounded,
          () => LinkedInService.launchProfile(),
        ),
        const SizedBox(width: 10),
        _buildMobileCircleIcon(
          Icons.code_rounded,
          () => GitHubService.launchProfile(),
        ),
        const SizedBox(width: 14),
        IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
          onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
        ),
      ],
    );
  }

  Widget _buildMobileCircleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF13151A),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.04)),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
      ),
    );
  }
}

// ----------------------------------------------------
// PRIVATE HOVER LINK COMPONENT WITH ACCENT SLIDERS
// ----------------------------------------------------
class _TabAnchorLink extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabAnchorLink({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_TabAnchorLink> createState() => _TabAnchorLinkState();
}

class _TabAnchorLinkState extends State<_TabAnchorLink> {
  final ValueNotifier<bool> _hoverState = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hoverState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverState.value = true,
      onExit: (_) => _hoverState.value = false,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: ValueListenableBuilder<bool>(
            valueListenable: _hoverState,
            builder: (context, hovered, _) {
              final bool isHighlighted = widget.isActive || hovered;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: isHighlighted
                          ? const Color(0xFF45F3FF)
                          : const Color(0xFF9CA3AF),
                    ),
                    child: Text(widget.label),
                  ),
                  const SizedBox(height: 6),

                  // Sliding underline track line indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    height: 2.5,
                    width: widget.isActive ? 20 : (hovered ? 12 : 0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF45F3FF),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        if (widget.isActive)
                          BoxShadow(
                            color: const Color(0xFF45F3FF).withOpacity(0.4),
                            blurRadius: 6,
                          ),
                      ],
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
