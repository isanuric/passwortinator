import 'package:flutter/material.dart';
import '../../models/password_strength.dart';

/// Premium strength indicator: status pill, entropy chip and an animated
/// segmented meter with a soft gradient glow.
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
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      container: true,
      label: 'Password strength: ${strength.label}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status pill + entropy chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: _statusPill(context, isDark: isDark),
              ),
              const SizedBox(width: 10),
              _entropyChip(context),
            ],
          ),
          const SizedBox(height: 14),

          // Animated segmented strength bar
          Row(
            children: [
              _buildBarSegment(
                context: context,
                activeColor: strength.color,
                isActive: true,
              ),
              const SizedBox(width: 6),
              _buildBarSegment(
                context: context,
                activeColor: strength.color,
                isActive: strength == PasswordStrength.medium ||
                    strength == PasswordStrength.strong,
              ),
              const SizedBox(width: 6),
              _buildBarSegment(
                context: context,
                activeColor: strength.color,
                isActive: strength == PasswordStrength.strong,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusPill(BuildContext context, {required bool isDark}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: strength.color.withValues(alpha: isDark ? 0.16 : 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: strength.color.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStrengthIcon(strength), size: 15, color: strength.color),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              'Strength: ${strength.label}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: strength.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _entropyChip(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        '${entropy.toStringAsFixed(1)} Bit Entropie',
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurfaceVariant,
        ),
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
        height: 8,
        decoration: BoxDecoration(
          color: isActive ? null : _inactiveColor(context),
          borderRadius: BorderRadius.circular(6),
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
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  Color _inactiveColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
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
