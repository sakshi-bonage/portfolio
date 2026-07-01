import 'package:flutter/material.dart';
import '../../../widgets/servicecard.dart';

class AboutSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const AboutSection({required this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 768;
        final bool isTablet = constraints.maxWidth >= 768 && constraints.maxWidth < 1100;
        
        final double horizontalPadding = isMobile 
            ? 24 
            : isTablet 
                ? 60 
                : 140;

        return Container(
          key: sectionKey,
          width: double.infinity,
          color: const Color(0xFF0D0E12),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: isMobile ? 80 : 120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionIndicator('ABOUT ME', [Colors.blueAccent, Colors.cyanAccent]),
              const SizedBox(height: 40),

              if (isMobile) ...[
                const _BioText(),
                const SizedBox(height: 48),
                _buildEducationTimeline(),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 5, 
                      child: _BioText(),
                    ),
                    SizedBox(width: isTablet ? 40 : 80),
                    Expanded(
                      flex: 4, 
                      child: _buildEducationTimeline(),
                    ),
                  ],
                ),

              const SizedBox(height: 100),
              _buildSectionIndicator('EXPERTISE & SERVICES', [Colors.cyanAccent, Colors.blueAccent]),
              const SizedBox(height: 48),

              if (isMobile)
                Column(
                  children: _getServiceCards(),
                )
              else if (isTablet)
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: _getServiceCards().map((card) => SizedBox(
                    width: (constraints.maxWidth - 120) / 2,
                    child: card,
                  )).toList(),
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

  Widget _buildSectionIndicator(String title, List<Color> colors) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white38,
            letterSpacing: 4,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  List<Widget> _getServiceCards() {
    return const [
      ServiceCard(
        title: 'Design',
        desc: 'Crafting stunning design systems that blend aesthetics with user-centered utility. Specialized in typography, responsive layouts, and modern UI paradigms.',
        icon: Icons.token_outlined,
      ),
      ServiceCard(
        title: 'Development',
        desc: 'Engineering bulletproof, native-speed cross-platform products using Flutter. Focused on clean architecture patterns and zero-jank frame metrics.',
        icon: Icons.terminal_outlined,
      ),
      ServiceCard(
        title: 'Maintenance',
        desc: 'Ensuring absolute structural uptime. Deploying iterative profiling optimizations, architectural migrations, and proactive code health scrubbing.',
        icon: Icons.query_stats_outlined,
      ),
    ];
  }

  Widget _buildEducationTimeline() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF13151A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.03),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
              'EXPERIENCE & EDUCATION',
              style: TextStyle(
                fontSize: 9,
                color: Colors.black,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 28),
          
          _buildTimelineNode(
            period: '2026 — PRESENT',
            title: 'Junior Flutter Developer Intern',
            institution: 'AskTechsolution',
            description: 'Architecting dynamic native widgets, standardizing asynchronous application layer configurations, and scaling interface modularity mechanics across mobile viewports.',
            isLatest: true,
          ),
          
          const Padding(
            padding: EdgeInsets.only(left: 4, top: 4, bottom: 12),
            child: SizedBox(
              height: 24,
              child: VerticalDivider(color: Colors.white10, width: 2, thickness: 1.5),
            ),
          ),

          _buildTimelineNode(
            period: '2024 — 2026',
            title: 'Diploma in Computer Engineering',
            institution: 'CSMSS Chh. Shahu College of Engineering',
            description: 'Immersed in computation frameworks, backend systems structures, and core algorithmic modeling architectures from the foundational first year forward.',
            isLatest: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode({
    required String period,
    required String title,
    required String institution,
    required String description,
    required bool isLatest,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLatest ? Colors.cyanAccent : Colors.white24,
              boxShadow: isLatest ? [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                )
              ] : null,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                period,
                style: TextStyle(
                  color: isLatest ? Colors.cyanAccent : Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                institution,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white60,
                  height: 1.5,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BioText extends StatelessWidget {
  const _BioText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Building dynamic interfaces, shaped with architectural precision.',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            height: 1.2,
            color: Colors.white,
            letterSpacing: -1.5,
          ),
        ),
        SizedBox(height: 24),
        Text(
          "I bridge the gap between complex software engineering systems and responsive user environments. As a mobile engineer specialized in cross-platform framework technologies, I build clean pipelines and fluid visual systems.",
          style: TextStyle(
            color: Colors.white60,
            fontSize: 15,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}
