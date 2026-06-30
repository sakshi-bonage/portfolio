import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget projectsSection(bool isMobile, {required GlobalKey key}) {
  return _AnimatedProjectsSection(isMobile: isMobile, sectionKey: key);
}

class _AnimatedProjectsSection extends StatefulWidget {
  final bool isMobile;
  final GlobalKey sectionKey;

  const _AnimatedProjectsSection({
    required this.isMobile,
    required this.sectionKey,
  });

  @override
  State<_AnimatedProjectsSection> createState() =>
      _AnimatedProjectsSectionState();
}

class _AnimatedProjectsSectionState extends State<_AnimatedProjectsSection> {
  final ValueNotifier<String> _selectedTab = ValueNotifier('ALL');

  final List<Map<String, dynamic>> _projects = [
    {
      'title': 'Challenging Hub App',
      'category': 'APPS',
      'description':
          'A modern fitness application developed using Flutter and Firebase. Features workout tracking, progress analytics, goal setting, authentication, and responsive UI design.',
      'imagePath': 'assets/project2.jpg',
      'tech': ['Flutter', 'Firebase', 'Analytics', 'UI/UX'],
      'url': 'https://github.com',
    },
    {
      'title': 'Mega Mall E-Commerce App',
      'category': 'APPS',
      'description':
          'A comprehensive digital storefront designed for scale. Featuring real-time inventory, secure checkout, and a designer-led UI system that prioritizes user conversion and brand loyalty.',
      'imagePath': 'assets/project1.jpg',
      'tech': ['Flutter', 'REST API', 'E-Commerce', 'State Management'],
      'url': 'https://github.com',
    },
  ];

  @override
  void dispose() {
    _selectedTab.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch project URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.sectionKey,
      width: double.infinity,
      color: const Color(0xFF0D0E12), // Cinematic deep background space
      padding: EdgeInsets.symmetric(
        horizontal: widget.isMobile ? 24 : 140,
        vertical: widget.isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Header Block
          Flex(
            direction: widget.isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: widget.isMobile
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECTED WORK',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.blueAccent.withValues(alpha: 0.8),
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'PROJECTS',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: widget.isMobile ? 24 : 0),

              // Filter Category Tab Selector Navigation
              ValueListenableBuilder<String>(
                valueListenable: _selectedTab,
                builder: (context, activeTab, _) {
                  final tabs = ['ALL', 'APPS', 'WEB', 'DESIGN'];
                  return Wrap(
                    spacing: widget.isMobile ? 12 : 24,
                    runSpacing: 10,
                    children: tabs.map((tab) {
                      final bool isSelected = activeTab == tab;
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _selectedTab.value = tab,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blueAccent.withValues(alpha: 0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blueAccent.withValues(alpha: 0.4)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Text(
                              tab,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.cyanAccent
                                    : const Color(0xFF627280),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 60),

          // Filterable Dynamic Stream Layout Grid View
          ValueListenableBuilder<String>(
            valueListenable: _selectedTab,
            builder: (context, currentFilter, _) {
              final filteredProjects = currentFilter == 'ALL'
                  ? _projects
                  : _projects
                        .where((p) => p['category'] == currentFilter)
                        .toList();

              if (filteredProjects.isEmpty) {
                return Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: const Text(
                    'No projects found in this category.',
                    style: TextStyle(color: Color(0xFF627280), fontSize: 16),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredProjects.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 40),
                itemBuilder: (context, index) {
                  final item = filteredProjects[index];
                  return _InteractiveProjectCard(
                    isMobile: widget.isMobile,
                    title: item['title']!,
                    description: item['description']!,
                    imagePath: item['imagePath']!,
                    techList: List<String>.from(item['tech']),
                    onViewPressed: () => _launchUrl(item['url']!),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InteractiveProjectCard extends StatefulWidget {
  final bool isMobile;
  final String title;
  final String description;
  final String imagePath;
  final List<String> techList;
  final VoidCallback onViewPressed;

  const _InteractiveProjectCard({
    required this.isMobile,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.techList,
    required this.onViewPressed,
  });

  @override
  State<_InteractiveProjectCard> createState() =>
      _InteractiveProjectCardState();
}

class _InteractiveProjectCardState extends State<_InteractiveProjectCard> {
  final ValueNotifier<bool> _isCardHovered = ValueNotifier(false);

  @override
  void dispose() {
    _isCardHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isCardHovered.value = true,
      onExit: (_) => _isCardHovered.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isCardHovered,
        builder: (context, isHovered, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.all(widget.isMobile ? 24 : 40),
            decoration: BoxDecoration(
              color: isHovered
                  ? const Color(0xFF161922)
                  : const Color(0xFF111319),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isHovered
                    ? Colors.blueAccent.withValues(alpha: 0.25)
                    : Colors.white.withValues(alpha: 0.03),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isHovered
                      ? Colors.blueAccent.withValues(alpha: 0.08)
                      : Colors.transparent,
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: child!,
          );
        },
        child: Flex(
          direction: widget.isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Content Block: Animated Image Layer
            Expanded(
              flex: widget.isMobile ? 0 : 5,
              child: ValueListenableBuilder<bool>(
                valueListenable: _isCardHovered,
                builder: (context, hovered, _) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    // FIXED LINE: Symmetrical 3D matrix coordinate vector mapping
                    transform: hovered
                        ? Matrix4.diagonal3Values(1.03, 1.03, 1.03)
                        : Matrix4.identity(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Image.asset(
                            widget.imagePath,
                            height: widget.isMobile ? 200 : 280,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: widget.isMobile ? 200 : 280,
                                  color: const Color(0xFF1B1D26),
                                  child: const Icon(
                                    Icons.broken_image_rounded,
                                    size: 40,
                                    color: Colors.white24,
                                  ),
                                ),
                          ),
                          Positioned.fill(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: hovered ? 0.2 : 0.5,
                              child: Container(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: widget.isMobile ? 0 : 48,
              height: widget.isMobile ? 28 : 0,
            ),

            // Right Content Block: Typography Text Metadata Information
            Expanded(
              flex: widget.isMobile ? 0 : 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FEATURED • FLUTTER',
                    style: TextStyle(
                      color: Colors.blueAccent.withValues(alpha: 0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      color: Color(0xFF9EAFBC),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Wrap Tech List Layout Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.techList
                        .map((tech) => _buildTechChip(tech))
                        .toList(),
                  ),
                  const SizedBox(height: 32),

                  // Text Button CTA trigger with Arrow Animation follow link logic
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: widget.onViewPressed,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _isCardHovered,
                        builder: (context, hovered, _) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'VIEW PROJECT',
                                style: TextStyle(
                                  color: hovered
                                      ? Colors.cyanAccent
                                      : Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                transform: hovered
                                    ? Matrix4.translationValues(6, 0, 0)
                                    : Matrix4.translationValues(0, 0, 0),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: hovered
                                      ? Colors.cyanAccent
                                      : Colors.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1E26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFB0C4DE),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
