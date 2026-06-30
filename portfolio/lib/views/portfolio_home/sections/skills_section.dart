import 'package:flutter/material.dart';

// ----------------------------------------------------
// 1. DATA CONFIGURATION MODELS
// ----------------------------------------------------
class SkillItem {
  final String name;
  final double mastery; // Value between 0.0 and 1.0 for graphic visual bars
  final String? svgPath;

  SkillItem({required this.name, required this.mastery, this.svgPath});
}

// ----------------------------------------------------
// 3. MAIN SECTION CONTAINER
// ----------------------------------------------------
Widget skillsSection(bool isMobile, {required GlobalKey key}) {
  return Container(
    key: key,
    width: double.infinity,
    color: const Color(0xFF0D0E12), // Deep Matte Space Canvas
    padding: EdgeInsets.symmetric(
      horizontal: isMobile ? 24 : 140,
      vertical: 120,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Subline
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
              'EXPERTISE MATRIX',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white38,
                letterSpacing: 4,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'TECHNICAL CAPABILITIES',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 64),

        // Core Layout Grid Split Responsive Flex Blocks
        Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSkillCard(
              isMobile,
              'USING NOW',
              'Core stack systems built with production architecture.',
              [
                SkillItem(
                  name: 'Dart',
                  mastery: 0.90,
                ),
                SkillItem(
                  name: 'Flutter',
                  mastery: 0.92,
                ),
                SkillItem(
                  name: 'Java',
                  mastery: 0.80,
                ),
                SkillItem(
                  name: 'Python',
                  mastery: 0.75,
                ),
                SkillItem(
                  name: 'Firebase',
                  mastery: 0.85,
                ),
              ],
            ),
            if (isMobile) const SizedBox(height: 24),
            _buildSkillCard(
              isMobile,
              'LEARNING NEXT',
              'Proactively expanding frameworks capabilities.',
              [
                SkillItem(
                  name: 'React',
                  mastery: 0.50,
                ),
                SkillItem(
                  name: 'Node.js',
                  mastery: 0.45,
                ),
                SkillItem(
                  name: 'MongoDB',
                  mastery: 0.55,
                ),
                SkillItem(
                  name: 'C++',
                  mastery: 0.70,
                ),
              ],
            ),
            if (isMobile) const SizedBox(height: 24),
            _buildSkillCard(
              isMobile,
              'DESIGN TOOLS',
              'Prototyping high-fidelity UI systems assets.',
              [
                SkillItem(
                  name: 'Figma',
                  mastery: 0.85,
                ),
                SkillItem(
                  name: 'Canva',
                  mastery: 0.90,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

// ----------------------------------------------------
// 4. SUB-DASHBOARD CARD ARCHITECTURE BUILDER
// ----------------------------------------------------
Widget _buildSkillCard(
  bool isMobile,
  String title,
  String description,
  List<SkillItem> items,
) {
  final content = Padding(
    padding: EdgeInsets.only(right: isMobile ? 0 : 24, bottom: 24),
    child: Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF13151A), // Clean isolated card contrast
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
          // Header Structural Text Elements
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.blueAccent,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white38,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),

          // Integrated Linear Status Metric Arrays
          ...items.map((skill) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        skill.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        '${(skill.mastery * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: skill.mastery,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.blueAccent, Colors.cyanAccent],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
  return isMobile ? content : Expanded(child: content);
}

// ----------------------------------------------------
// EXPERT CARD COMPONENT WITH 3D PERSPECTIVE FLUIDITY
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
          // Processes depth transformation and directional tilt matrix coordinates
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

