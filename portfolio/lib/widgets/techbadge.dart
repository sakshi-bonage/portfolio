import 'package:flutter/material.dart';

class TechBadge extends StatefulWidget {
  final String label;
  final IconData? icon;

  const TechBadge({
    required this.label,
    this.icon,
    super.key,
  });

  @override
  State<TechBadge> createState() => _TechBadgeState();
}

class _TechBadgeState extends State<TechBadge> {
  final ValueNotifier<bool> _isHovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      cursor: SystemMouseCursors.click,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isHovered,
        builder: (context, hovered, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              // Changes to solid dark color on hover with bright cyber borders
              color: hovered 
                  ? const Color(0xFF141D26) 
                  : const Color(0xFF13151A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hovered
                    ? const Color(0xFF45F3FF).withValues(alpha: 0.35)
                    : Colors.white.withValues(alpha: 0.04),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF45F3FF).withValues(
                    alpha: hovered ? 0.08 : 0.0,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 16,
                    color: hovered 
                        ? const Color(0xFF45F3FF) 
                        : const Color(0xFF9CA3AF),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: hovered ? Colors.white : const Color(0xFF9CA3AF),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
