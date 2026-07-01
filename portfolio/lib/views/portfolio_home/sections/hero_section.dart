import 'package:flutter/material.dart';

Widget buildHeroSection(bool isMobile) {
  return _PremiumVolumetricHero(isMobile: isMobile);
}

class _PremiumVolumetricHero extends StatefulWidget {
  final bool isMobile;
  const _PremiumVolumetricHero({required this.isMobile});

  @override
  State<_PremiumVolumetricHero> createState() => _PremiumVolumetricHeroState();
}

class _PremiumVolumetricHeroState extends State<_PremiumVolumetricHero>
    with SingleTickerProviderStateMixin {
  // HIGH-PERFORMANCE WORKFLOW: Bypasses heavy global redrawing loops completely
  final ValueNotifier<Matrix4> _tiltMatrix = ValueNotifier(Matrix4.identity());
  final ValueNotifier<Offset> _mousePos = ValueNotifier(Offset.zero);
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isTextHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isCtaHovered = ValueNotifier(false);

  // Staggered Entrance Animation Engine Controller Configuration
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    // Fires off the staggered entry timeline immediately on page construction
    _entranceController.forward();
  }

  @override
  void dispose() {
    _tiltMatrix.dispose();
    _mousePos.dispose();
    _isHovered.dispose();
    _isTextHovered.dispose();
    _isCtaHovered.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _handleMouseMovement(
    PointerEvent event,
    Size boundary,
    double paddingHorizontal,
  ) {
    if (widget.isMobile) {
      return;
    }

    _mousePos.value = Offset(
      event.localPosition.dx - 200 - paddingHorizontal,
      event.localPosition.dy - 200 - 140,
    );

    final midX = boundary.width / 2;
    final midY = boundary.height / 2;
    final tiltY = ((event.localPosition.dx - midX) / midX) * 0.12;
    final tiltX = ((event.localPosition.dy - midY) / midY) * -0.12;

    _tiltMatrix.value = Matrix4.identity()
      ..setEntry(
        3,
        2,
        0.001,
      ) // 3D Perspective Projection factor depth mapping parameter
      ..rotateX(tiltX)
      ..rotateY(tiltY);
  }

  void _resetMouseEffects() {
    _isHovered.value = false;
    _tiltMatrix.value = Matrix4.identity();
  }

  // Refactored Entrance Engine utilizing fluid mathematical interval overlapping curves
  Widget _buildStaggeredEntrance({
    required double startInterval,
    required Widget child,
  }) {
    final Animation<double> sequenceAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Interval(
              startInterval,
              (startInterval + 0.45).clamp(0.0, 1.0),
              curve: Curves.easeOutCubic,
            ),
          ),
        );

    return AnimatedBuilder(
      animation: sequenceAnimation,
      builder: (context, childWidget) {
        return Transform.translate(
          offset: Offset(0, 24 * (1.0 - sequenceAnimation.value)),
          child: Opacity(opacity: sequenceAnimation.value, child: childWidget),
        );
      },
      child: child,
    );
  }

  Widget _buildResponsiveFlexChild({
    required bool isStacked,
    required int flex,
    required Widget child,
  }) {
    return isStacked ? child : Flexible(flex: flex, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isTablet = width < 1100;
    final bool isStacked = widget.isMobile || isTablet;
    final size = MediaQuery.of(context).size;
    final double layoutHorizontalPadding = width > 1400
        ? 140
        : width > 1000
        ? 80
        : 24;

    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onHover: (event) =>
          _handleMouseMovement(event, size, layoutHorizontalPadding),
      onExit: (_) => _resetMouseEffects(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: layoutHorizontalPadding,
          vertical: widget.isMobile ? 60 : 120,
        ),
        color: const Color(
          0xFF0B0C10,
        ), // Matched deep portfolio space dark background
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Ambient Spotlight Tracking Frame (Hidden completely on mobile)
            if (!widget.isMobile)
              ValueListenableBuilder<bool>(
                valueListenable: _isHovered,
                builder: (context, hovered, _) {
                  if (!hovered) return const SizedBox.shrink();
                  return ValueListenableBuilder<Offset>(
                    valueListenable: _mousePos,
                    builder: (context, pos, childWidget) {
                      return Positioned(
                        left: pos.dx,
                        top: pos.dy,
                        child: childWidget!,
                      );
                    },
                    child: IgnorePointer(
                      child: Container(
                        width: 400,
                        height: 400,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF45F3FF).withValues(alpha: 0.08),
                              const Color(0xFF00B4D8).withValues(alpha: 0.02),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            // Main Responsive Multi-Column Structural Grid
            Flex(
              direction: isStacked ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // LEFT SIDE COLUMN: Interactive Typography Copywriting Engine
                _buildResponsiveFlexChild(
                  isStacked: isStacked,
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Subtitle Status Banner Badge
                      _buildStaggeredEntrance(
                        startInterval: 0.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF45F3FF,
                            ).withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(
                                0xFF45F3FF,
                              ).withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.greenAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'AVAILABLE FOR FREELANCE & FULL-TIME',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF45F3FF),
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Premium Animated Main Identity Headline
                      _buildStaggeredEntrance(
                        startInterval: 0.15,
                        child: MouseRegion(
                          onEnter: (_) => _isTextHovered.value = true,
                          onExit: (_) => _isTextHovered.value = false,
                          cursor: SystemMouseCursors.click,
                          child: ValueListenableBuilder<bool>(
                            valueListenable: _isTextHovered,
                            builder: (context, textHovered, child) {
                              return AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                                style: TextStyle(
                                  fontSize: widget.isMobile ? 38 : 54,
                                  fontWeight: FontWeight.w900,
                                  height: 1.15,
                                  color: textHovered
                                      ? const Color(0xFF45F3FF)
                                      : Colors.white,
                                  shadows: textHovered
                                      ? [
                                          Shadow(
                                            color: const Color(
                                              0xFF45F3FF,
                                            ).withValues(alpha: 0.4),
                                            blurRadius: 20,
                                          ),
                                        ]
                                      : [],
                                  letterSpacing: -1.5,
                                ),
                                child: const Text(
                                  'Hi, I am\nSakshi Rajebhau\nBonage',
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Gradient Subtext Role Descriptor
                      _buildStaggeredEntrance(
                        startInterval: 0.3,
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF45F3FF), Color(0xFF00B4D8)],
                          ).createShader(bounds),
                          child: Text(
                            'Junior Flutter Developer & Computer Engineering Student',
                            style: TextStyle(
                              fontSize: widget.isMobile ? 18 : 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Core Professional Pitch Paragraph
                      _buildStaggeredEntrance(
                        startInterval: 0.45,
                        child: const Text(
                          'I bridge the gap between complex engineering codebases and flawless visual designs. Specialized in compiling zero-latency cross-platform application systems wrapped in clean branding interfaces.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF9CA3AF),
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Magnetic Download Resume Button Module
                      _buildStaggeredEntrance(
                        startInterval: 0.6,
                        child: MouseRegion(
                          onEnter: (event) => _isCtaHovered.value = true,
                          onExit: (event) => _isCtaHovered.value = false,
                          child: ValueListenableBuilder(
                            valueListenable: _isCtaHovered,
                            builder: (context, ctaHovered, _) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                transform: ctaHovered
                                    ? Matrix4.translationValues(0, -4, 0)
                                    : Matrix4.identity(),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF45F3FF).withValues(
                                        alpha: ctaHovered ? 0.25 : 0.0,
                                      ),
                                      blurRadius: 15,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Connected link triggers will integrate here
                                  },
                                  icon: Icon(
                                    Icons.arrow_downward_rounded,
                                    size: 18,
                                    color: ctaHovered
                                        ? Colors.white
                                        : const Color(0xFF0B0C10),
                                  ),
                                  label: const Text(
                                    'DOWNLOAD RESUME',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                      fontSize: 13,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ctaHovered
                                        ? const Color(0xFF141D26)
                                        : const Color(0xFF45F3FF),
                                    foregroundColor: ctaHovered
                                        ? Colors.white
                                        : const Color(0xFF0B0C10),
                                    side: BorderSide(
                                      color: ctaHovered
                                          ? const Color(0xFF45F3FF)
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: widget.isMobile ? 24 : 32,
                                      vertical: widget.isMobile ? 18 : 22,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (!widget.isMobile && !isStacked) const SizedBox(width: 48),
                if (isStacked) const SizedBox(height: 48),

                // RIGHT SIDE COLUMN: Interactive 3D Photo Parallax Component Container
                _buildResponsiveFlexChild(
                  isStacked: isStacked,
                  flex: 4,
                  child: Container(
                    margin: EdgeInsets.only(top: widget.isMobile ? 48 : 0),
                    alignment: Alignment.center,
                    child: ValueListenableBuilder(
                      valueListenable: _tiltMatrix,
                      builder: (context, transformMatrix, childWidget) {
                        return Transform(
                          transform: transformMatrix,
                          alignment: FractionalOffset.center,
                          child: childWidget!,
                        );
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          // Background Decorative Parallax Border Line Frame
                          ValueListenableBuilder(
                            valueListenable: _isHovered,
                            builder: (context, hovered, _) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: widget.isMobile ? 260 : 320,
                                height: widget.isMobile ? 320 : 400,
                                transform: hovered
                                    ? Matrix4.translationValues(-12, -12, 0)
                                    : Matrix4.translationValues(-20, -20, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: hovered
                                        ? const Color(
                                            0xFF45F3FF,
                                          ).withValues(alpha: 0.5)
                                        : const Color(0xFF1F2937),
                                    width: 2,
                                  ),
                                ),
                              );
                            },
                          ),

                          // Front High-Performance Image Container Layout Card Wrapper
                          ValueListenableBuilder(
                            valueListenable: _isHovered,
                            builder: (context, hovered, childWidget) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: widget.isMobile ? 260 : 320,
                                height: widget.isMobile ? 320 : 400,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF141D26,
                                  ), // Elevated surface container depth card matching portfolio theme
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: hovered
                                        ? const Color(
                                            0xFF45F3FF,
                                          ).withValues(alpha: 0.2)
                                        : const Color(0xFF1F2937),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: hovered
                                          ? const Color(
                                              0xFF45F3FF,
                                            ).withValues(alpha: 0.15)
                                          : Colors.black45,
                                      blurRadius: hovered ? 40 : 20,
                                      offset: Offset(0, hovered ? 16 : 8),
                                    ),
                                  ],
                                ),
                                child: childWidget!,
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                'assets/profile.jpg',
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 50,
                                      color: Colors.white24,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
