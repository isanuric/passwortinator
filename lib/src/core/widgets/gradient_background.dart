import 'package:flutter/material.dart';

/// Ambient gradient backdrop with soft colored glows.
///
/// Renders a full-bleed, slowly hierarchical dark gradient plus several
/// blurred radial "aurora" blobs, painted behind the app content.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF070B16), Color(0xFF0D1230), Color(0xFF080C1B)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -160,
            left: -120,
            child: _Glow(color: Color(0xFF5B3BE6), opacity: 0.30),
          ),
          Positioned(
            bottom: -190,
            right: -140,
            child: _Glow(color: Color(0xFF2B6BFF), opacity: 0.18),
          ),
          Positioned(
            top: 40,
            right: 30,
            child: _Glow(color: Color(0xFF9B6CFF), opacity: 0.12),
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
