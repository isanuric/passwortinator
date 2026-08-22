import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/password_generator_provider.dart';
import '../clipboard_utils.dart';
import 'strength_indicator.dart';

/// Card widget displaying the generated password with copy action and strength indicator.
///
/// Watches only `password`, `strength` and `entropy` – it rebuilds when the
/// password or its strength changes, but not on unrelated state updates.
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
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with label and action icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Generated password',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      tooltip: 'Regenerate',
                      iconSize: 22,
                      color: colorScheme.primary,
                      onPressed: notifier.regenerate,
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded),
                      tooltip: 'Copy',
                      iconSize: 22,
                      color: colorScheme.primary,
                      onPressed: () =>
                          ClipboardUtils.copyWithFeedback(context, password),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Password text container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                    : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: SelectableText(
                password,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: _calculateFontSize(password.length),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: colorScheme.onSurface,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Integrated strength indicator
            StrengthIndicator(
              strength: strength,
              entropy: entropy,
            ),
          ],
        ),
      ),
    );
  }

  /// Dynamically adjusts font size based on password length for optimal visual presentation.
  double _calculateFontSize(int length) {
    if (length <= 16) {
      return 22.0;
    } else if (length <= 24) {
      return 18.0;
    } else if (length <= 40) {
      return 16.0;
    } else {
      return 14.0;
    }
  }
}