import 'package:flutter/material.dart';
import '../../../services/git_service.dart';
import '../../../services/linkedin_service.dart';

class FooterSection extends StatelessWidget {
  final bool isMobile;
  final ScrollController scrollController;

  const FooterSection({
    super.key,
    required this.isMobile,
    required this.scrollController,
  });

  // Common function to scroll the page smoothly to the very top
  void _scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year.toString();

    return Container(
      color: const Color(0xFF0B0C10),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 40,
        vertical: isMobile ? 32 : 24,
      ),
      child: isMobile
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '<> SRB',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF45F3FF),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Interactive Animated Social Links
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _HoverBounceIcon(
                      icon: Icons.link_rounded,
                      tooltip: 'LinkedIn',
                      onTap: () => LinkedInService.launchProfile(),
                    ),
                    const SizedBox(width: 12),
                    _HoverBounceIcon(
                      icon: Icons.code_rounded,
                      tooltip: 'GitHub',
                      onTap: () => GitHubService.launchProfile(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                Text(
                  '© $currentYear Sakshi Rajebhau Bonage.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Built with precision.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF4A5568), fontSize: 11),
                ),
                const SizedBox(height: 20),
                
                // Compact Mobile Scroll Shortcut Button
                OutlinedButton.icon(
                  onPressed: _scrollToTop,
                  icon: const Icon(Icons.arrow_upward_rounded, size: 14),
                  label: const Text(
                    "BACK TO TOP",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF45F3FF),
                    side: const BorderSide(color: Color(0xFF1F2937)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '<> SRB',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color(0xFF45F3FF),
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  '© $currentYear Sakshi Rajebhau Bonage. Built with precision.',
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                  ),
                ),
                
                // Unified Controls Row Group
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _HoverBounceIcon(
                      icon: Icons.link_rounded,
                      tooltip: 'LinkedIn',
                      onTap: () => LinkedInService.launchProfile(),
                    ),
                    const SizedBox(width: 12),
                    _HoverBounceIcon(
                      icon: Icons.code_rounded,
                      tooltip: 'GitHub',
                      onTap: () => GitHubService.launchProfile(),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      height: 24,
                      width: 1,
                      color: const Color(0xFF1F2937),
                    ),
                    const SizedBox(width: 16),
                    
                    // Desktop Quick Scroll Shortcut Button
                    Tooltip(
                      message: 'Back to Top',
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _scrollToTop,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF141D26),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF1F2937)),
                            ),
                            child: const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Color(0xFF45F3FF),
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

// Statefully managed micro-component translating mouse gestures to spring-loaded bounce scaling vectors
class _HoverBounceIcon extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _HoverBounceIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_HoverBounceIcon> createState() => _HoverBounceIconState();
}

class _HoverBounceIconState extends State<_HoverBounceIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    // Creates an elastic, springy bounce curve mapping scale up properties
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeOutBack, // Gives that precise premium spring rebound sensation
      ),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _bounceController.forward(),
      onExit: (_) => _bounceController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Tooltip(
          message: widget.tooltip,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF141D26),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF1F2937),
                  width: 1,
                ),
              ),
              child: Icon(
                widget.icon,
                color: const Color(0xFF45F3FF),
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
