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
        final bool isTablet =
            constraints.maxWidth >= 768 && constraints.maxWidth < 1100;

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
              _buildSectionIndicator('ABOUT ME', [
                Colors.blueAccent,
                Colors.cyanAccent,
              ]),
              const SizedBox(height: 40),

              if (isMobile) ...[const _BioText()] else const _BioText(),
              const SizedBox(height: 100),
              _buildSectionIndicator('EXPERTISE & SERVICES', [
                Colors.cyanAccent,
                Colors.blueAccent,
              ]),
              const SizedBox(height: 48),

              if (isMobile)
                Column(children: _getServiceCards())
              else if (isTablet)
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: _getServiceCards()
                      .map(
                        (card) => SizedBox(
                          width: (constraints.maxWidth - 120) / 2,
                          child: card,
                        ),
                      )
                      .toList(),
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getServiceCards()
                      .map((card) => Expanded(child: card))
                      .toList(),
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
        desc:
            'Crafting stunning design systems that blend aesthetics with user-centered utility. Specialized in typography, responsive layouts, and modern UI paradigms.',
        icon: Icons.token_outlined,
      ),
      ServiceCard(
        title: 'Development',
        desc:
            'Engineering bulletproof, native-speed cross-platform products using Flutter. Focused on clean architecture patterns and zero-jank frame metrics.',
        icon: Icons.terminal_outlined,
      ),
      ServiceCard(
        title: 'Maintenance',
        desc:
            'Ensuring absolute structural uptime. Deploying iterative profiling optimizations, architectural migrations, and proactive code health scrubbing.',
        icon: Icons.query_stats_outlined,
      ),
    ];
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
          "I am a passionate Flutter Developer and Computer Engineering student currently working as a Junior Flutter Developer Intern at AskTechsolution. I specialize in building responsive mobile and web applications using Flutter, with a strong focus on clean UI, performance, and user experience.\n\nI have developed projects including MegaMall E-Commerce App, ChallengingHub Daily Challenge App, and my personal Portfolio Website. I enjoy turning ideas into real-world applications and continuously learning new technologies to improve my development skills.",
          style: TextStyle(color: Colors.white60, fontSize: 15, height: 1.7),
        ),
      ],
    );
  }
}
