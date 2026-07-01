import 'package:flutter/material.dart';

// ----------------------------------------------------
// 1. DATA CONFIGURATION LAYERS
// ----------------------------------------------------
class SkillItem {
  final String name;
  final double mastery; // Value between 0.0 and 1.0 for graphic visual bars
  final String? svgPath;

  const SkillItem({
    required this.name,
    required this.mastery,
    this.svgPath,
  });
}

// ----------------------------------------------------
// 2. MAIN SECTION CONTAINER
// ----------------------------------------------------
class SkillsSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const SkillsSection({required this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 768;
    final bool isTablet = width >= 768 && width < 1100;
    final bool isStacked = isMobile || isTablet;

    return Container(
      key: sectionKey,
      width: double.infinity,
      color: const Color(0xFF0D0E12), // Deep Matte Space Canvas
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
            direction: isStacked ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildResponsiveChild(
                isStacked: isStacked,
                child: const _SkillDashboardCard(
                  title: 'USING NOW',
                  description: 'Core stack systems built with production architecture.',
                  items: [
                    SkillItem(name: 'Dart', mastery: 0.90),
                    SkillItem(name: 'Flutter', mastery: 0.92),
                    SkillItem(name: 'Java', mastery: 0.80),
                    SkillItem(name: 'Python', mastery: 0.75),
                    SkillItem(name: 'Firebase', mastery: 0.85),
                  ],
                ),
              ),
              if (isStacked) const SizedBox(height: 32),
              _buildResponsiveChild(
                isStacked: isStacked,
                child: const _SkillDashboardCard(
                  title: 'LEARNING NEXT',
                  description: 'Proactively expanding frameworks capabilities.',
                  items: [
                    SkillItem(name: 'React', mastery: 0.50),
                    SkillItem(name: 'Node.js', mastery: 0.45),
                    SkillItem(name: 'MongoDB', mastery: 0.55),
                    SkillItem(name: 'C++', mastery: 0.70),
                  ],
                ),
              ),
              if (isStacked) const SizedBox(height: 32),
              _buildResponsiveChild(
                isStacked: isStacked,
                child: const _SkillDashboardCard(
                  title: 'DESIGN TOOLS',
                  description: 'Prototyping high-fidelity UI systems assets.',
                  items: [
                    SkillItem(name: 'Figma', mastery: 0.85),
                    SkillItem(name: 'Canva', mastery: 0.90),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveChild({required bool isStacked, required Widget child}) {
    return isStacked ? child : Expanded(child: child);
  }
}

// ----------------------------------------------------
// 3. SUB-DASHBOARD CARD ARCHITECTURE
// ----------------------------------------------------
class _SkillDashboardCard extends StatelessWidget {
  final String title;
  final String description;
  final List<SkillItem> items;

  const _SkillDashboardCard({
    required this.title,
    required this.description,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 768;

    return Padding(
      padding: EdgeInsets.only(right: isMobile ? 0 : 24),
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
          mainAxisSize: MainAxisSize.min,
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

            // Integrated Linear Status Metric Rows
            ...items.map((skill) => _SkillProgressMetricRow(skill: skill)),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 4. ANIMATED PROGRESS BAR COEFFICIENT ROW
// ----------------------------------------------------
class _SkillProgressMetricRow extends StatefulWidget {
  final SkillItem skill;

  const _SkillProgressMetricRow({required this.skill});

  @override
  State<_SkillProgressMetricRow> createState() => _SkillProgressMetricRowState();
}

class _SkillProgressMetricRowState extends State<_SkillProgressMetricRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _barAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _barAnimation = Tween<double>(begin: 0.0, end: widget.skill.mastery).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOutCubic,
      ),
    );

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.skill.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(widget.skill.mastery * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Layout-Safe Horizontal Linear Metric Track
          AnimatedBuilder(
            animation: _barAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: _barAnimation.value,
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blueAccent, Colors.cyanAccent],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
