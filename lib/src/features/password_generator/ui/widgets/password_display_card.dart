import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/password_strength.dart';
import 'strength_indicator.dart';

/// Card widget displaying the generated password with copy action and strength indicator.
class PasswordDisplayCard extends StatelessWidget {
  const PasswordDisplayCard({
    super.key,
    required this.password,
    required this.strength,
    required this.entropy,
    required this.onRegenerate,
  });

  final String password;
  final PasswordStrength strength;
  final double entropy;
  final VoidCallback onRegenerate;

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              'Passwort kopiert!',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1E293B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      'Generiertes Passwort',
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
                      tooltip: 'Neu generieren',
                      iconSize: 22,
                      color: colorScheme.primary,
                      onPressed: onRegenerate,
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded),
                      tooltip: 'Kopieren',
                      iconSize: 22,
                      color: colorScheme.primary,
                      onPressed: () => _copyToClipboard(context),
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
                    ? colorScheme.surfaceVariant.withOpacity(0.3)
                    : colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.4),
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
