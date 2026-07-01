import 'package:flutter/material.dart';

// ----------------------------------------------------
// 1. DATA LAYERING CONFIGURATION MODEL
// ----------------------------------------------------
class ExperienceItem {
  final String period;
  final String role;
  final String company;
  final String description;
  final List<String> technologies;
  final bool isCurrent;

  const ExperienceItem({
    required this.period,
    required this.role,
    required this.company,
    required this.description,
    required this.technologies,
    this.isCurrent = false,
  });
}

// ----------------------------------------------------
// 2. MAIN TIMELINE CONTAINER VIEWPORT
// ----------------------------------------------------
class ExperienceSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const ExperienceSection({required this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 950;

    // Ordered career history nodes matching your background parameters
    final List<ExperienceItem> items = [
      const ExperienceItem(
        period: '2026 — PRESENT',
        role: 'Junior Flutter Developer Intern',
        company: 'AskTechsolution',
        description: 'Architecting dynamic native layouts, implementing asynchronous state streams, and standardizing multi-viewport compatibility modules across mobile and web deployments.',
        technologies: ['Flutter', 'Dart', 'State Management', 'REST APIs', 'Git'],
        isCurrent: true,
      ),
      const ExperienceItem(
        period: '2024 — 2026',
        role: 'Computer Engineering Project Lead',
        company: 'CSMSS Chh. Shahu College of Engineering',
        description: 'Designed internal algorithm management tool assemblies, directed developer workshops, and engineered responsive cross-platform structural mock projects.',
        technologies: ['Java', 'Python', 'UI Architecture', 'Data Structures'],
        isCurrent: false,
      ),
    ];

    return Container(
      key: sectionKey,
      width: double.infinity,
      color: const Color(0xFF0D0E12), // Deep Cinematic Dark Base Canvas
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 140,
        vertical: isMobile ? 80 : 120,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Header Indicators
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
                'CAREER JOURNEY',
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
            'PROFESSIONAL EXPERIENCE',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 64),

          // Adaptive Stream Renderer Loop
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _ExperienceTimelineNode(
                item: items[index],
                isLast: index == items.length - 1,
                isMobile: isMobile,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// 3. RESPONSIVE TIMELINE NODE ENGINE
// ----------------------------------------------------
class _ExperienceTimelineNode extends StatefulWidget {
  final ExperienceItem item;
  final bool isLast;
  final bool isMobile;

  const _ExperienceTimelineNode({
    required this.item,
    required this.isLast,
    required this.isMobile,
  });

  @override
  State<_ExperienceTimelineNode> createState() => _ExperienceTimelineNodeState();
}

class _ExperienceTimelineNodeState extends State<_ExperienceTimelineNode> {
  final ValueNotifier<bool> _isNodeHovered = ValueNotifier(false);

  @override
  void dispose() {
    _isNodeHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isNodeHovered.value = true,
      onExit: (_) => _isNodeHovered.value = false,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column (Desktop Only): Period Timestamp
            if (!widget.isMobile) ...[
              SizedBox(
                width: 120,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isNodeHovered,
                    builder: (context, hovered, _) {
                      return Text(
                        widget.item.period,
                        style: TextStyle(
                          color: hovered || widget.item.isCurrent
                              ? const Color(0xFF45F3FF)
                              : Colors.white38,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 24),
            ],

            // Center Column: Interactive Central Node Branch Line
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isNodeHovered,
                    builder: (context, hovered, _) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hovered || widget.item.isCurrent
                              ? const Color(0xFF45F3FF)
                              : Colors.white12,
                          boxShadow: hovered || widget.item.isCurrent
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF45F3FF).withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  )
                                ]
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                if (!widget.isLast)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: 2,
                        color: Colors.white.withOpacity(0.04),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 32),

            // Right Column: Information Content Card Panel
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 48.0),
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isNodeHovered,
                  builder: (context, hovered, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: hovered ? const Color(0xFF161922) : const Color(0xFF13151A),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: hovered
                              ? const Color(0xFF45F3FF).withOpacity(0.2)
                              : Colors.white.withOpacity(0.03),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: hovered
                                ? const Color(0xFF45F3FF).withOpacity(0.04)
                                : Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: child!,
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Period Display for Mobile Layout stacking configurations
                      if (widget.isMobile) ...[
                        Text(
                          widget.item.period,
                          style: const TextStyle(
                                    color: const Color(0xFF45F3FF),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              Text(
                                widget.item.role,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.item.company,
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.item.description,
                                style: const TextStyle(
                                  color: Color(0xFF9EAFBC),
                                  height: 1.6,
                                  fontSize: 13.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              // Localized Micro-Tag Chip Capsules Layout Wrap
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: widget.item.technologies.map((tech) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1B1E26),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.02),
                                      ),
                                    ),
                                    child: Text(
                                      tech,
                                      style: const TextStyle(
                                        color: Color(0xFFB0C4DE),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                  ),
                
          ],
            
          ),
      ),
        );
      
    
  }
}
