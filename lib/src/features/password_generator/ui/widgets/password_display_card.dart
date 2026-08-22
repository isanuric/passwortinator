import 'dart:async';
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

  /// Fixed height of the password field. Chosen to comfortably fit the longest
  /// allowed password (64 chars, smallest font) wrapping to 3 lines.
  static const double _passwordFieldHeight = 72;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (password, strength, entropy) = ref.watch(
      passwordGeneratorProvider.select(
        (s) => (s.password, s.strength, s.entropy),
      ),
    );
    final cs = Theme.of(context).colorScheme;

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
                  key: const Key('password-switcher'),
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: Container(
                    key: ValueKey(password),
                    // Fixed height: the field never grows or shrinks regardless
                    // of how many lines the password wraps to.
                    height: _passwordFieldHeight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          cs.surfaceContainerHigh.withValues(alpha: 0.45),
                          cs.surfaceContainerHigh.withValues(alpha: 0.12),
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
          _InlineCopyButton(password: password),
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

/// Inline copy button with self-contained feedback.
///
/// On tap it copies the password and briefly swaps its icon to a checkmark.
/// It shows no snack bar, so it can never cover the bottom action buttons.
class _InlineCopyButton extends StatefulWidget {
  const _InlineCopyButton({required this.password});

  final String password;

  @override
  State<_InlineCopyButton> createState() => _InlineCopyButtonState();
}

class _InlineCopyButtonState extends State<_InlineCopyButton> {
  bool _copied = false;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleCopy() async {
    await ClipboardUtils.copy(widget.password);
    if (!mounted) return;
    setState(() => _copied = true);
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: _copied
            ? cs.primaryContainer.withValues(alpha: 0.8)
            : cs.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: _copied
              ? cs.primary.withValues(alpha: 0.6)
              : cs.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: IconButton(
        icon: Icon(
          _copied ? Icons.check_rounded : Icons.copy_rounded,
          size: 17,
        ),
        color: _copied ? cs.primary : cs.onSurfaceVariant,
        tooltip: 'Copy',
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        onPressed: _handleCopy,
      ),
    );
  }
}