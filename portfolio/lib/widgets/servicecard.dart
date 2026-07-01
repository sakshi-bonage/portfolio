import 'package:flutter/material.dart';

class ServiceCard extends StatefulWidget {
  final String title;
  final String desc;
  final IconData icon;

  const ServiceCard({
    required this.title,
    required this.desc,
    required this.icon,
    super.key,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> with SingleTickerProviderStateMixin {
  double _targetX = 0.0;
  double _targetY = 0.0;
  double _lerpX = 0.0;
  double _lerpY = 0.0;
  bool _isHovered = false;
  late AnimationController _physicsController;

  @override
  void initState() {
    super.initState();
    _physicsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_applySmoothInterpolation);
  }

  void _applySmoothInterpolation() {
    if (!mounted) return;
    setState(() {
      // Elastic 12% frame dampening matrix creates premium organic spring responses
      _lerpX = _lerpX + (_targetX - _lerpX) * 0.12;
      _lerpY = _lerpY + (_targetY - _lerpY) * 0.12;
    });

    if (_isHovered && (_targetX - _lerpX).abs() > 0.001 || (_targetY - _lerpY).abs() > 0.001) {
      _physicsController.forward(from: 0.0);
    }
  }

  void _updateGestureOffset(PointerEvent details, Size size) {
    final double xPos = details.localPosition.dx / size.width;
    final double yPos = details.localPosition.dy / size.height;

    _targetX = (0.5 - yPos) * 0.20; 
    _targetY = (xPos - 0.5) * 0.20; 
    
    if (!_physicsController.isAnimating) {
      _physicsController.forward(from: 0.0);
    }
  }

  void _resetGestureOffset() {
    _targetX = 0.0;
    _targetY = 0.0;
    if (!_physicsController.isAnimating) {
      _physicsController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _physicsController.dispose();
    super.dispose();
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
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.all(12),
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012) 
              ..rotateX(_lerpX)
              ..rotateY(_lerpY),
            decoration: BoxDecoration(
              color: const Color(0xFF13151A),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _isHovered
                    ? Colors.cyanAccent.withValues(alpha: 0.35)
                    : Colors.white.withValues(alpha: 0.03),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? Colors.cyanAccent.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.2),
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isHovered ? Colors.blueAccent : const Color(0xFF1A1D24),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        if (_isHovered)
                          BoxShadow(
                            color: Colors.blueAccent.withValues(alpha: 0.35),
                            blurRadius: 14,
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
