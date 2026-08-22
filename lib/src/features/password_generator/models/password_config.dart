import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';

/// Available character categories for password generation.
enum PasswordCategory {
  uppercase(
    title: 'Großbuchstaben',
    subtitle: 'A-Z',
    example: 'ABC...',
  ),
  lowercase(
    title: 'Kleinbuchstaben',
    subtitle: 'a-z',
    example: 'abc...',
  ),
  numbers(
    title: 'Zahlen',
    subtitle: '0-9',
    example: '123...',
  ),
  special(
    title: 'Sonderzeichen',
    subtitle: r'!@#$%^&*...',
    example: '!@#...',
  );

  const PasswordCategory({
    required this.title,
    required this.subtitle,
    required this.example,
  });

  final String title;
  final String subtitle;
  final String example;
}

/// Immutable configuration model for password generation parameters.
@immutable
class PasswordConfig {
  const PasswordConfig({
    this.length = AppConstants.defaultPasswordLength,
    this.includeUppercase = true,
    this.includeLowercase = true,
    this.includeNumbers = true,
    this.includeSpecial = true,
  });

  /// The desired length of the generated password.
  final int length;

  /// Whether to include uppercase letters (A-Z).
  final bool includeUppercase;

  /// Whether to include lowercase letters (a-z).
  final bool includeLowercase;

  /// Whether to include numeric digits (0-9).
  final bool includeNumbers;

  /// Whether to include special punctuation characters.
  final bool includeSpecial;

  /// Returns the number of currently active character categories.
  int get activeCategoriesCount {
    int count = 0;
    if (includeUppercase) count++;
    if (includeLowercase) count++;
    if (includeNumbers) count++;
    if (includeSpecial) count++;
    return count;
  }

  /// Calculates the total character pool size (R) based on active categories.
  ///
  /// Pool sizes:
  /// - a-z: 26
  /// - A-Z: 26
  /// - 0-9: 10
  /// - Sonderzeichen: 32
  int get totalPoolSize {
    int poolSize = 0;
    if (includeUppercase) poolSize += AppConstants.uppercasePoolSize;
    if (includeLowercase) poolSize += AppConstants.lowercasePoolSize;
    if (includeNumbers) poolSize += AppConstants.numberPoolSize;
    if (includeSpecial) poolSize += AppConstants.specialPoolSize;
    return poolSize;
  }

  /// Checks whether a specific category is enabled.
  bool isCategoryEnabled(PasswordCategory category) {
    switch (category) {
      case PasswordCategory.uppercase:
        return includeUppercase;
      case PasswordCategory.lowercase:
        return includeLowercase;
      case PasswordCategory.numbers:
        return includeNumbers;
      case PasswordCategory.special:
        return includeSpecial;
    }
  }

  /// Determines whether a category can be toggled off.
  ///
  /// Validation rule: At least one category must remain active at all times.
  /// If only one category is active and it's this category, it cannot be disabled.
  bool canDisableCategory(PasswordCategory category) {
    if (!isCategoryEnabled(category)) {
      // Enabling an inactive category is always allowed
      return true;
    }
    // Disabling is only allowed if more than 1 category is currently active
    return activeCategoriesCount > 1;
  }

  /// Creates a copy of this config with the specified fields replaced.
  PasswordConfig copyWith({
    int? length,
    bool? includeUppercase,
    bool? includeLowercase,
    bool? includeNumbers,
    bool? includeSpecial,
  }) {
    return PasswordConfig(
      length: length ?? this.length,
      includeUppercase: includeUppercase ?? this.includeUppercase,
      includeLowercase: includeLowercase ?? this.includeLowercase,
      includeNumbers: includeNumbers ?? this.includeNumbers,
      includeSpecial: includeSpecial ?? this.includeSpecial,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordConfig &&
          runtimeType == other.runtimeType &&
          length == other.length &&
          includeUppercase == other.includeUppercase &&
          includeLowercase == other.includeLowercase &&
          includeNumbers == other.includeNumbers &&
          includeSpecial == other.includeSpecial;

  @override
  int get hashCode => Object.hash(
        length,
        includeUppercase,
        includeLowercase,
        includeNumbers,
        includeSpecial,
      );

  @override
  String toString() {
    return 'PasswordConfig(length: $length, uppercase: $includeUppercase, '
        'lowercase: $includeLowercase, numbers: $includeNumbers, special: $includeSpecial)';
  }
}
