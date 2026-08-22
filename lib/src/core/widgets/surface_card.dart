import 'package:flutter/material.dart';

/// Premium frosted surface used by the main content cards.
///
/// A soft, lightly translucent card with rounded corners, a subtle border and
/// a gentle layered shadow. The child sits on a transparent [Material] so ink
/// splashes (e.g. from `ListTile`s) render correctly. Set [glow] to true for
/// the hero card to get a tinted brand glow instead of a neutral shadow.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.glow = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest.withValues(alpha: isDark ? 0.68 : 1),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: isDark ? 0.5 : 0.6),
        ),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: cs.primary.withValues(
                    alpha: isDark ? 0.24 : 0.10,
                  ),
                  blurRadius: 42,
                  offset: const Offset(0, 20),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark ? 0.35 : 0.06,
                  ),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
      ),
      child: Material(
        type: MaterialType.transparency,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(28),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
