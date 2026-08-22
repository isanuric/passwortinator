import 'package:flutter/material.dart';
import '../../models/password_strength.dart';

/// Visual indicator for password entropy and calculated strength.
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength status and entropy value row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  _getStrengthIcon(strength),
                  size: 18,
                  color: strength.color,
                ),
                const SizedBox(width: 6),
                Text(
                  'Strength: ${strength.label}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: strength.color,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: strength.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: strength.color.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                '${entropy.toStringAsFixed(1)} Bit Entropie',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: strength.color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Segmented Strength Bar
        Row(
          children: [
            _buildBarSegment(
              context: context,
              index: 0,
              activeColor: strength.color,
              isActive: true,
            ),
            const SizedBox(width: 6),
            _buildBarSegment(
              context: context,
              index: 1,
              activeColor: strength.color,
              isActive: strength == PasswordStrength.medium ||
                  strength == PasswordStrength.strong,
            ),
            const SizedBox(width: 6),
            _buildBarSegment(
              context: context,
              index: 2,
              activeColor: strength.color,
              isActive: strength == PasswordStrength.strong,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBarSegment({
    required BuildContext context,
    required int index,
    required Color activeColor,
    required bool isActive,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.08);

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 8,
        decoration: BoxDecoration(
          color: isActive ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  IconData _getStrengthIcon(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return Icons.shield_outlined;
      case PasswordStrength.medium:
        return Icons.security_outlined;
      case PasswordStrength.strong:
        return Icons.verified_user_rounded;
    }
  }
}
