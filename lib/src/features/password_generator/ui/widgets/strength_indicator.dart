import 'package:flutter/material.dart';
import '../../models/password_strength.dart';

/// Minimal strength indicator: a compact segmented meter plus the entropy
/// value in bits. No pills, no extra labels – just the essential signal.
class StrengthIndicator extends StatelessWidget {
  const StrengthIndicator({
    super.key,
    required this.strength,
    required this.entropy,
  });

  final PasswordStrength strength;
  final double entropy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      container: true,
      label: 'Password strength: ${strength.label}',
      child: Row(
        children: [
          // Animated segmented strength bar
          Expanded(
            child: Row(
              children: [
                _buildBarSegment(
                  context: context,
                  activeColor: strength.color,
                  isActive: true,
                ),
                const SizedBox(width: 4),
                _buildBarSegment(
                  context: context,
                  activeColor: strength.color,
                  isActive: strength == PasswordStrength.medium ||
                      strength == PasswordStrength.strong,
                ),
                const SizedBox(width: 4),
                _buildBarSegment(
                  context: context,
                  activeColor: strength.color,
                  isActive: strength == PasswordStrength.strong,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${entropy.toStringAsFixed(0)} Bit',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarSegment({
    required BuildContext context,
    required Color activeColor,
    required bool isActive,
  }) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        height: 5,
        decoration: BoxDecoration(
          color: isActive ? null : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(4),
          gradient: isActive
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    activeColor,
                    activeColor.withValues(alpha: 0.65),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}