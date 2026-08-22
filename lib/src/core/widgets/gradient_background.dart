import 'package:flutter/material.dart';

/// Ambient gradient backdrop with soft colored glows.
///
/// Renders a full-bleed, slowly hierarchical gradient plus several blurred
/// radial "aurora" blobs. It is painted behind the app content and reacts to
/// the current brightness.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF070B16), Color(0xFF0D1230), Color(0xFF080C1B)]
              : const [Color(0xFFEEF1FE), Color(0xFFF6F3FF), Color(0xFFE6F0FF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -160,
            left: -120,
            child: _Glow(
              color: isDark ? const Color(0xFF5B3BE6) : const Color(0xFF4A3FDB),
              opacity: isDark ? 0.30 : 0.20,
            ),
          ),
          Positioned(
            bottom: -190,
            right: -140,
            child: _Glow(
              color: isDark ? const Color(0xFF2B6BFF) : const Color(0xFF2B7FFF),
              opacity: isDark ? 0.18 : 0.12,
            ),
          ),
          Positioned(
            top: 40,
            right: 30,
            child: _Glow(
              color: isDark ? const Color(0xFF9B6CFF) : const Color(0xFFB58BFF),
              opacity: isDark ? 0.12 : 0.10,
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.opacity});

  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
