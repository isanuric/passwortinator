import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Represents the calculated strength level of a password based on entropy.
enum PasswordStrength {
  weak(
    label: 'Weak',
    color: Color(0xFFE53935), // Red
    fraction: 0.33,
  ),
  medium(
    label: 'Medium',
    color: Color(0xFFFFB300), // Amber / Yellow
    fraction: 0.66,
  ),
  strong(
    label: 'Strong',
    color: Color(0xFF43A047), // Green
    fraction: 1.0,
  );

  const PasswordStrength({
    required this.label,
    required this.color,
    required this.fraction,
  });

  /// Maps an entropy value (in bits) to the corresponding [PasswordStrength].
  ///
  /// - E < 50 Bit = Weak
  /// - 50 <= E < 70 Bit = Medium
  /// - E >= 70 Bit = Strong
  factory PasswordStrength.fromEntropy(double entropy) {
    if (entropy < AppConstants.weakThreshold) {
      return PasswordStrength.weak;
    } else if (entropy < AppConstants.strongThreshold) {
      return PasswordStrength.medium;
    } else {
      return PasswordStrength.strong;
    }
  }

  /// Display text label for the strength level.
  final String label;

  /// Semantic theme color for visual indication.
  final Color color;

  /// Normalized progress bar fraction (0.0 - 1.0).
  final double fraction;
}
