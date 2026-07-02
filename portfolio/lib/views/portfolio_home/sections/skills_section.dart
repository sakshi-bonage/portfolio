import 'package:flutter/material.dart';

// ----------------------------------------------------
// 1. DATA CONFIGURATION LAYERS
// ----------------------------------------------------
class TechSkill {
  final String name;
  final String assetPath;
  final Color brandColor;

  const TechSkill({
    required this.name,
    required this.assetPath,
    required this.brandColor,
  });
}

// ----------------------------------------------------
// 2. MAIN RESPONSIVE SKILLS GRID CONTAINER
// ----------------------------------------------------
class SkillsSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const SkillsSection({required this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1024;

    final List<TechSkill> skillsList = [
      const TechSkill(
        name: 'Flutter',
        assetPath: 'assets/images/flutter.png',
        brandColor: Colors.blueAccent,
      ),
      const TechSkill(
        name: 'Dart',
        assetPath: 'assets/images/dart.png',
        brandColor: Colors.cyanAccent,
      ),
      const TechSkill(
        name: 'Java',
        assetPath: 'assets/images/java.png',
        brandColor: Colors.orangeAccent,
      ),
      const TechSkill(
        name: 'C',
        assetPath: 'assets/images/c.png',
        brandColor: Color.fromARGB(255, 104, 100, 230),
      ),
      const TechSkill(
        name: 'C++',
        assetPath: 'assets/images/cpp.png',
        brandColor: Colors.blue,
      ),
      const TechSkill(
        name: 'HTML',
        assetPath: 'assets/images/html.png',
        brandColor: Colors.deepOrange,
      ),
      const TechSkill(
        name: 'CSS',
        assetPath: 'assets/images/css.png',
        brandColor: Color.fromARGB(255, 8, 56, 143),
      ),
      const TechSkill(
        name: 'React',
        assetPath: 'assets/images/react.png',
        brandColor: Colors.lightBlueAccent,
      ),
      const TechSkill(
        name: 'Firebase',
        assetPath: 'assets/images/firebase.png',
        brandColor: Color.fromARGB(255, 199, 116, 9),
      ),
      const TechSkill(
        name: 'MongoDB',
        assetPath: 'assets/images/mongodb.png',
        brandColor: Colors.greenAccent,
      ),
      const TechSkill(
        name: 'Python',
        assetPath: 'assets/images/python.png',
        brandColor: Color.fromARGB(255, 190, 220, 81),
      ),
      const TechSkill(
        name: 'Github',
        assetPath: 'assets/images/github.png',
        brandColor: Colors.white,
      ),
      const TechSkill(
        name: 'Figma',
        assetPath: 'assets/images/figma.png',
        brandColor: Colors.deepPurpleAccent,
      ),
    ];

    return Container(
      key: sectionKey,
      width: double.infinity,
      color: const Color(0xFF0D0E12),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : (isTablet ? 60 : 140),
        vertical: isMobile ? 60 : 100,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              // Header
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
                    'MY EXPERTISE',
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
                'TECHNICAL SKILLS',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(
                width: 650,
                child: Text(
                  'Technologies, frameworks and tools I use to build modern applications.',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                    height: 1.7,
                  ),
                ),
              ),
              const SizedBox(height: 64),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: skillsList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 2 : 4,
                  crossAxisSpacing: isMobile ? 12 : 20,
                  mainAxisSpacing: isMobile ? 12 : 20,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  return _SkillTileCard(skill: skillsList[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 3. SKILL TILE BLOCK WITH TILT & TRACING GLOW SHIMMER
// ----------------------------------------------------
class _SkillTileCard extends StatefulWidget {
  final TechSkill skill;

  const _SkillTileCard({required this.skill});

  @override
  State<_SkillTileCard> createState() => _SkillTileCardState();
}

class _SkillTileCardState extends State<_SkillTileCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  double _rotateX = 0.0;
  double _rotateY = 0.0;

  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    // Continuous loop for the border shimmer tracing motion
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  void _updateTilt(PointerEvent details, BoxConstraints constraints) {
    final double centerX = constraints.maxWidth / 2;
    final double centerY = constraints.maxHeight / 2;

    setState(() {
      _isHovered = true;
      _rotateX = (centerY - details.localPosition.dy) / centerY * 0.12;
      _rotateY = (details.localPosition.dx - centerX) / centerX * 0.12;
    });
  }

  void _resetTilt() {
    setState(() {
      _isHovered = false;
      _rotateX = 0.0;
      _rotateY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onHover: (details) => _updateTilt(details, constraints),
          onExit: (_) => _resetTilt(),
          child: AnimatedTransform(
            duration: const Duration(milliseconds: 150),
            alignment: Alignment.center,

            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateX(_rotateX)
              ..rotateY(_rotateY)
              ..scale(_isHovered ? 1.04 : 1.0, _isHovered ? 1.04 : 1.0, 1.0),

            child: AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _BorderGlowPainter(
                    animationValue: _shimmerController.value,
                    glowColor: widget.skill.brandColor,
                    isHovered: _isHovered,
                  ),
                  child : Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF14161D),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        if (_isHovered)
                          BoxShadow(
                            color: widget.skill.brandColor.withValues(
                              alpha: 0.15,
                            ),
                            blurRadius: 25,
                            spreadRadius: -2,
                          ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            widget.skill.assetPath,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.skill.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------
// 4. CUSTOM PAINTER FOR TRACING BORDER GLOW HIGH-FX
// ----------------------------------------------------
class _BorderGlowPainter extends CustomPainter {
  final double animationValue;
  final Color glowColor;
  final bool isHovered;

  _BorderGlowPainter({
    required this.animationValue,
    required this.glowColor,
    required this.isHovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double borderRadius = 16.0;
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    // Baseline subtle border paint
    final Paint baseBorderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withValues(alpha: isHovered ? 0.05 : 0.02);

    canvas.drawRRect(rrect, baseBorderPaint);

    // Sweeping high-intensity tracking neon glow paint
    final Paint glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isHovered ? 2.0 : 1.5
      ..shader = SweepGradient(
        center: Alignment.center,
        // Continuous sweep rotation transformation calculation mapping
        transform: GradientRotation(animationValue * 2 * 3.141592653589793),
        colors: [
          glowColor.withValues(alpha: 0.0),
          glowColor.withValues(
            alpha: isHovered ? 0.8 : 0.3,
          ), // Spikes illumination intensity on active pointer target
          glowColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Optional blur overlay mask to mimic a continuous light tube dispersion halo
    if (isHovered) {
      glowPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    }

    canvas.drawRRect(rrect, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _BorderGlowPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isHovered != isHovered ||
        oldDelegate.glowColor != glowColor;
  }
}

// ----------------------------------------------------
// 5. ANIMATED TRANSFORM HELPER COMPONENT
// ----------------------------------------------------
class AnimatedTransform extends StatelessWidget {
  final Widget child;
  final Matrix4 transform;
  final Duration duration;
  final Alignment alignment;

  const AnimatedTransform({
    required this.child,
    required this.transform,
    required this.duration,
    this.alignment = Alignment.center,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Matrix4>(
      tween: MatrixRouteTween(begin: Matrix4.identity(), end: transform),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) =>
          Transform(transform: value, alignment: alignment, child: child),
      child: child,
    );
  }
}

class MatrixRouteTween extends Tween<Matrix4> {
  MatrixRouteTween({super.begin, super.end});

  @override
  Matrix4 lerp(double t) {
    final Matrix4 beginMatrix = begin ?? Matrix4.identity();
    final Matrix4 endMatrix = end ?? Matrix4.identity();

    // Uses the built-in, optimized Flutter matrix calculation directly
    return Matrix4Tween(begin: beginMatrix, end: endMatrix).lerp(t);
  }
}
