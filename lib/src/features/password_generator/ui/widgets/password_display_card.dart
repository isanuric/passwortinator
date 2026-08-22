import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../logic/password_generator_provider.dart';
import '../clipboard_utils.dart';
import 'strength_indicator.dart';

/// Minimal hero card: the password with an inline copy action and the compact
/// strength indicator. No header, no labels – the password is the focus.
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
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SurfaceCard(
      glow: true,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Password field
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: Container(
                    key: ValueKey(password),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
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
                                cs.surfaceContainerHighest
                                    .withValues(alpha: 0.55),
                                cs.surfaceContainerHighest
                                    .withValues(alpha: 0.25),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(14),
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
                        letterSpacing: 1.0,
                        color: cs.onSurface,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Strength indicator
                StrengthIndicator(strength: strength, entropy: entropy),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Copy action, vertically centered next to the password
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.copy_rounded, size: 17),
              color: cs.onSurfaceVariant,
              tooltip: 'Copy',
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              onPressed: () =>
                  ClipboardUtils.copyWithFeedback(context, password),
            ),
          ),
        ],
      ),
    );
  }

  /// Dynamically adjusts font size based on password length.
  double _calculateFontSize(int length) {
    if (length <= 12) return 20.0;
    if (length <= 20) return 17.0;
    if (length <= 32) return 14.5;
    if (length <= 48) return 13.0;
    return 11.5;
  }
}