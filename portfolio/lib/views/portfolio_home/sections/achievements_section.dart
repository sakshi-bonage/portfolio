import 'package:flutter/material.dart';

// ----------------------------------------------------
// MAIN ACHIEVEMENTS CLASS VIEWPORT SECTION
// ----------------------------------------------------
class AchievementsSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const AchievementsSection({required this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    // Read contextual viewport dimensions instantly inside the build thread
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 768;
    final bool isTablet = width >= 768 && width < 1100;
    final bool isStacked = isMobile || isTablet;

    return Container(
      key: sectionKey,
      width: double.infinity,
      color: const Color(0xFF0D0E12), // Premium Dark Cyber Canvas
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 140,
        vertical: isMobile ? 80 : 120,
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
                'MILESTONES',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white38,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'ACHIEVEMENTS',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              height: 1.2,
              color: Colors.white,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 56),

          // Fully Responsive Adaptive Cross-Platform Layout Engine
          if (isStacked)
            const Column(
              children: [
                _Achievement3DCard(
                  tag: 'ECOSYSTEM',
                  title: 'Flutter Apps',
                  body: 'Successfully deployed multiple production-ready applications on Play Store with emphasis on smooth UI/UX.',
                  icon: Icons.layers,
                ),
                _Achievement3DCard(
                  tag: 'E-COMMERCE',
                  title: 'Mega Mall App',
                  body: 'Developed a feature-rich E-Commerce solution with complex state management and seamless payment integration.',
                  icon: Icons.shopping_bag_outlined,
                ),
                _Achievement3DCard(
                  tag: 'ALGORITHMS',
                  title: 'Problem Solving',
                  body: 'Solved 500+ challenges across platforms like LeetCode and GeeksForGeeks, focusing on Data Structures.',
                  icon: Icons.code,
                ),
              ],
            )
          else
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Achievement3DCard(
                    tag: 'ECOSYSTEM',
                    title: 'Flutter Apps',
                    body: 'Successfully deployed multiple production-ready applications on Play Store with emphasis on smooth UI/UX.',
                    icon: Icons.layers,
                  ),
                ),
                Expanded(
                  child: _Achievement3DCard(
                    tag: 'E-COMMERCE',
                    title: 'Mega Mall App',
                    body: 'Developed a feature-rich E-Commerce solution with complex state management and seamless payment integration.',
                    icon: Icons.shopping_bag_outlined,
                  ),
                ),
                Expanded(
                  child: _Achievement3DCard(
                    tag: 'ALGORITHMS',
                    title: 'Problem Solving',
                    body: 'Solved 500+ challenges across platforms like LeetCode and GeeksForGeeks, focusing on Data Structures.',
                    icon: Icons.code,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// MILESTONE CARD ENGINE WITH 3D PERSPECTIVE GESTURES
// ----------------------------------------------------
class _Achievement3DCard extends StatefulWidget {
  final String tag;
  final String title;
  final String body;
  final IconData icon;

  const _Achievement3DCard({
    required this.tag,
    required this.title,
    required this.body,
    required this.icon,
  });

  @override
  State<_Achievement3DCard> createState() => _Achievement3DCardState();
}

class _Achievement3DCardState extends State<_Achievement3DCard> {
  double _rotateX = 0.0;
  double _rotateY = 0.0;
  bool _isHovered = false;

  void _updateGestureOffset(PointerEvent details, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final double xPos = details.localPosition.dx / size.width;
    final double yPos = details.localPosition.dy / size.height;

    setState(() {
      // Dynamic tilt adjustment matrix coefficients
      _rotateX = (0.5 - yPos) * 0.20; 
      _rotateY = (xPos - 0.5) * 0.20; 
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
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.all(12),
            // Performs depth rendering transformations
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012) // Depth perspective scale
              ..rotateX(_rotateX)
              ..rotateY(_rotateY),
            decoration: BoxDecoration(
              color: const Color(0xFF13151A),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _isHovered
                    ? Colors.cyanAccent.withOpacity(0.3)
                    : Colors.white.withOpacity(0.03),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? Colors.cyanAccent.withOpacity(0.05)
                      : Colors.black.withOpacity(0.2),
                  blurRadius: _isHovered ? 45 : 30,
                  offset: Offset(0, _isHovered ? 20 : 12),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated Interactive Floating Icon Wrapper
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isHovered ? Colors.blueAccent : const Color(0xFF1A1D24),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        if (_isHovered)
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
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
                  
                  // Meta Tag Element
                  Text(
                    widget.tag,
                    style: TextStyle(
                      color: _isHovered ? Colors.cyanAccent : Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Main Core Title Heading
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
                  
                  // Micro Copy Body Block
                  Text(
                    widget.body,
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
