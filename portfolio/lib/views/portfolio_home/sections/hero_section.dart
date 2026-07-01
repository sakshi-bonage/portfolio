import 'package:flutter/material.dart';
class HeroSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const HeroSection({required this.sectionKey, super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 768;

    return Container(
      key: sectionKey,
      child: _PremiumVolumetricHero(isMobile: isMobile),
    );
  }
}

Widget buildHeroSection(bool isMobile) {
  return HeroSection(sectionKey: GlobalKey());
}

class _PremiumVolumetricHero extends StatefulWidget {
  final bool isMobile;
  const _PremiumVolumetricHero({required this.isMobile});

  @override
  State<_PremiumVolumetricHero> createState() => _PremiumVolumetricHeroState();
}

class _PremiumVolumetricHeroState extends State<_PremiumVolumetricHero>
    with TickerProviderStateMixin {
  final ValueNotifier<Matrix4> _tiltMatrix = ValueNotifier(Matrix4.identity());
  final ValueNotifier<Offset> _mousePos = ValueNotifier(Offset.zero);
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isTextHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isCtaHovered = ValueNotifier(false);

  late AnimationController _entranceController;
  late AnimationController _textTickerController;

  double _targetTiltX = 0.0;
  double _targetTiltY = 0.0;
  double _currentTiltX = 0.0;
  double _currentTiltY = 0.0;
  late AnimationController _tickerPhysicsLoop;

  final String _targetHeadlineName = "Hi, I am\nSakshi Rajebhau\nBonage";

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _textTickerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _textTickerController.forward();
    });

    _tickerPhysicsLoop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_interpolateParallaxSprings);
  }

  void _interpolateParallaxSprings() {
    if (!mounted) return;

    _currentTiltX = _currentTiltX + (_targetTiltX - _currentTiltX) * 0.15;
    _currentTiltY = _currentTiltY + (_targetTiltY - _currentTiltY) * 0.15;

    _tiltMatrix.value = Matrix4.identity()
      ..setEntry(3, 2, 0.0012)
      ..rotateX(_currentTiltX)
      ..rotateY(_currentTiltY);

    if (_isHovered.value &&
        ((_targetTiltX - _currentTiltX).abs() > 0.001 ||
            (_targetTiltY - _currentTiltY).abs() > 0.001)) {
      _tickerPhysicsLoop.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _tiltMatrix.dispose();
    _mousePos.dispose();
    _isHovered.dispose();
    _isTextHovered.dispose();
    _isCtaHovered.dispose();
    _entranceController.dispose();
    _textTickerController.dispose();
    _tickerPhysicsLoop.dispose();
    super.dispose();
  }

  void _handleMouseMovement(PointerEvent event, Size boundary, double paddingHorizontal) {
    if (widget.isMobile) return;

    _mousePos.value = Offset(
      event.localPosition.dx - 200,
      event.localPosition.dy - 200,
    );

    final midX = boundary.width / 2;
    final midY = boundary.height / 2;

    _targetTiltY = ((event.localPosition.dx - midX) / midX) * 0.15;
    _targetTiltX = ((event.localPosition.dy - midY) / midY) * -0.15;

    if (!_tickerPhysicsLoop.isAnimating) {
      _tickerPhysicsLoop.forward(from: 0.0);
    }
  }

  void _resetMouseEffects() {
    _isHovered.value = false;
    _targetTiltX = 0.0;
    _targetTiltY = 0.0;
    if (!_tickerPhysicsLoop.isAnimating) {
      _tickerPhysicsLoop.forward(from: 0.0);
    }
  }

  Widget _buildStaggeredEntrance({required double startInterval, required Widget child}) {
    final Animation<double> sequenceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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

  Widget _buildResponsiveFlexChild({required bool isStacked, required int flex, required Widget child}) {
    return isStacked ? child : Flexible(flex: flex, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isTablet = width < 1100;
    final bool isStacked = widget.isMobile || isTablet;
    final size = MediaQuery.of(context).size;
    final double layoutHorizontalPadding = width > 1400 ? 140 : width > 1000 ? 80 : 24;

    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onHover: (event) => _handleMouseMovement(event, size, layoutHorizontalPadding),
      onExit: (_) => _resetMouseEffects(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: layoutHorizontalPadding,
          vertical: widget.isMobile ? 60 : 120,
        ),
        color: const Color(0xFF0B0C10),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
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

            Flex(
              direction: isStacked ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // LEFT COLUMN
                _buildResponsiveFlexChild(
                  isStacked: isStacked,
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStaggeredEntrance(
                        startInterval: 0.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF45F3FF).withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF45F3FF).withValues(alpha: 0.15)),
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

                      _buildStaggeredEntrance(
                        startInterval: 0.15,
                        child: MouseRegion(
                          onEnter: (_) => _isTextHovered.value = true,
                          onExit: (_) => _isTextHovered.value = false,
                          cursor: SystemMouseCursors.click,
                          child: ValueListenableBuilder(
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
                                            color: const Color(0xFF45F3FF)
                                                .withValues(alpha: 0.4),
                                            blurRadius: 20,
                                          ),
                                        ]
                                      : [],
                                  letterSpacing: -1.5,
                                ),
                                child: AnimatedBuilder(
                                  animation: _textTickerController,
                                  builder: (context, _) {
                                    int count = (_textTickerController.value *
                                            _targetHeadlineName.length)
                                        .floor();
                                    String currentString =
                                        _targetHeadlineName.substring(0, count);
                                    return Text(currentString);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

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
                                          alpha: ctaHovered ? 0.25 : 0.0),
                                      blurRadius: 15,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () {},
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
                                        fontSize: 13),
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
                                        width: 1.5),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: widget.isMobile ? 24 : 32,
                                      vertical: widget.isMobile ? 18 : 22,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
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

                // RIGHT COLUMN
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
                                        ? const Color(0xFF45F3FF).withValues(alpha: 0.5)
                                        : const Color(0xFF1F2937),
                                    width: 2,
                                  ),
                                ),
                              );
                            },
                          ),

                          ValueListenableBuilder(
                            valueListenable: _isHovered,
                            builder: (context, hovered, childWidget) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: widget.isMobile ? 260 : 320,
                                height: widget.isMobile ? 320 : 400,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF141D26),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: hovered
                                        ? const Color(0xFF45F3FF).withValues(alpha: 0.2)
                                        : const Color(0xFF1F2937),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: hovered
                                          ? const Color(0xFF45F3FF).withValues(alpha: 0.15)
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
                                'assets/images/profile.jpeg',
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
