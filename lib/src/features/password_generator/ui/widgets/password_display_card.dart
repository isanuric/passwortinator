import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../logic/password_generator_provider.dart';
import '../clipboard_utils.dart';
import 'strength_indicator.dart';

/// Hero card displaying the generated password with premium styling,
/// regenerate and copy actions, and the strength indicator.
///
/// Watches only `password`, `strength` and `entropy`.
class PasswordDisplayCard extends ConsumerWidget {
  const PasswordDisplayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (password, strength, entropy) = ref.watch(
      passwordGeneratorProvider.select(
        (s) => (s.password, s.strength, s.entropy),
      ),
    );
    final notifier = ref.read(passwordGeneratorProvider.notifier);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SurfaceCard(
      glow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with label and action icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _brandBadge(cs: cs),
                  const SizedBox(width: 12),
                  Text(
                    'Generated password',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _IconAction(
                    icon: Icons.refresh_rounded,
                    tooltip: 'Regenerate',
                    onPressed: notifier.regenerate,
                  ),
                  const SizedBox(width: 8),
                  _IconAction(
                    icon: Icons.copy_rounded,
                    tooltip: 'Copy',
                    onPressed: () =>
                        ClipboardUtils.copyWithFeedback(context, password),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Password field
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: Container(
              key: ValueKey(password),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          cs.surfaceContainerHigh.withValues(alpha: 0.45),
                          cs.surfaceContainerHigh.withValues(alpha: 0.12),
                        ]
                      : [
                          cs.surfaceContainerHighest.withValues(alpha: 0.55),
                          cs.surfaceContainerHighest.withValues(alpha: 0.25),
                        ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: SelectableText(
                password,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: _calculateFontSize(password.length),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: cs.onSurface,
                  height: 1.35,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Strength indicator
          StrengthIndicator(strength: strength, entropy: entropy),
        ],
      ),
    );
  }

  Widget _brandBadge({required ColorScheme cs}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child:
          const Icon(Icons.lock_person_rounded, color: Colors.white, size: 22),
    );
  }

  /// Dynamically adjusts font size based on password length.
  double _calculateFontSize(int length) {
    if (length <= 12) return 24.0;
    if (length <= 20) return 20.0;
    if (length <= 32) return 17.0;
    if (length <= 48) return 15.0;
    return 13.5;
  }
}

/// Compact circular action button used in the hero card header.
class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: IconButton(
        icon: Icon(icon, size: 19),
        color: cs.onSurfaceVariant,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        onPressed: onPressed,
      ),
    );
  }
}
