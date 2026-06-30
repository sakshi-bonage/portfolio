import 'package:flutter/material.dart';

class AboutSection extends StatefulWidget {
  final GlobalKey sectionKey;

  const AboutSection({required this.sectionKey, super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 950;
        final double horizontalPadding = isMobile ? 24 : 140;

        return Container(
          key: widget.sectionKey,
          width: double.infinity,
          color: const Color(0xFF0D0E12), // Premium Dark Cyber Canvas
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header Indicator Subline
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.cyanAccent],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'ABOUT ME',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white38,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Split Layout Viewport
              if (!isMobile)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _buildBioText()),
                    const SizedBox(width: 80),
                    Expanded(flex: 4, child: _buildEducationTimeline()),
                  ],
                )
              else ...[
                _buildBioText(),
                const SizedBox(height: 56),
                _buildEducationTimeline(),
              ],

              const SizedBox(height: 100),

              // Services Section Header
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.cyanAccent, Colors.blueAccent],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'EXPERTISE & SERVICES',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white38,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Responsive Expert Card Layout Grid
              if (isMobile)
                Column(
                  children: _getServiceCards(),
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getServiceCards().map((card) => Expanded(child: card)).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _getServiceCards() {
    return const [
      _ServiceCard(
        title: 'Design',
        desc: 'Crafting stunning design systems that blend aesthetics with user-centered utility. Specialized in typography, responsive layouts, and modern UI paradigms.',
        icon: Icons.token_outlined,
      ),
      _ServiceCard(
        title: 'Development',
        desc: 'Engineering bulletproof, native-speed cross-platform products using Flutter. Focused on clean architecture patterns and zero-jank frame metrics.',
        icon: Icons.terminal_outlined,
      ),
      _ServiceCard(
        title: 'Maintenance',
        desc: 'Ensuring absolute structural uptime. Deploying iterative profiling optimizations, architectural migrations, and proactive code health scrubbing.',
        icon: Icons.query_stats_outlined,
      ),
    ];
  }

  Widget _buildBioText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Building dynamic interfaces, shaped with architectural precision.',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w900,
            height: 1.2,
            color: Colors.white,
            letterSpacing: -1.5,
          ),
        ),
        SizedBox(height: 28),
        Text(
          "I bridge the gap between complex engineering systems and beautiful user environments. Currently engineering software solutions while looking for collaborative projects alongside teams globally.",
          style: TextStyle(
            color: Colors.white60, 
            fontSize: 15, 
            height: 1.7,
          ),
        ),
      ],
    );
  }

  Widget _buildEducationTimeline() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF13151A), // Isolated card contrast
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.03),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blueAccent, Colors.cyanAccent],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'EDUCATION',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.blueAccent, Colors.cyanAccent],
            ).createShader(bounds),
            child: const Text(
              '2024 — PRESENT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Diploma in Computer Engineering',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'CSMSS Chh. Shahu College of Engineering',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Immersed in computation frameworks, system methodologies, and algorithms. Actively directing dev workshops and holding high-tier academic tracking metrics.',
            style: TextStyle(
              color: Colors.white60,
              height: 1.6,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// SERVICE CARD ENGINE WITH 3D PERSPECTIVE GESTURES
// ----------------------------------------------------
class _ServiceCard extends StatefulWidget {
  final String title;
  final String desc;
  final IconData icon;

  const _ServiceCard({
    required this.title,
    required this.desc,
    required this.icon,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  double _rotateX = 0.0;
  double _rotateY = 0.0;
  bool _isHovered = false;

  void _updateGestureOffset(PointerEvent details, Size size) {
    final double xPos = details.localPosition.dx / size.width;
    final double yPos = details.localPosition.dy / size.height;

    setState(() {
      _rotateX = (0.5 - yPos) * 0.15; 
      _rotateY = (xPos - 0.5) * 0.15; 
    });
  }

  void _resetGestureOffset() {
    setState(() {
      _rotateX = 0.0;
      _rotateY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardSize = Size(constraints.maxWidth, constraints.maxHeight);

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onHover: (details) => _updateGestureOffset(details, cardSize),
          onExit: (_) {
            setState(() => _isHovered = false);
            _resetGestureOffset();
          },
          child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.all(12),
          // Performs depth rendering transformations
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_rotateX)
            ..rotateY(_rotateY),
          decoration: BoxDecoration(
            color: const Color(0xFF13151A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered
                  ? Colors.cyanAccent.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.03),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? Colors.cyanAccent.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.2),
                blurRadius: _isHovered ? 45 : 30,
                offset: Offset(0, _isHovered ? 18 : 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isHovered ? Colors.blueAccent : const Color(0xFF1A1D24),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (_isHovered)
                        BoxShadow(
                          color: Colors.blueAccent.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Icon(
                    widget.icon,
                    size: 26,
                    color: _isHovered ? Colors.black : Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.desc,
                  style: const TextStyle(
                    color: Colors.white60,
                    height: 1.65,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ),
        );
      },
    );
  }
}
