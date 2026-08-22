import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';

/// Available character categories for password generation.
enum PasswordCategory {
  uppercase,
  lowercase,
  numbers,
  special,
  specialStrict,
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
    this.includeSpecialStrict = false,
    this.excludeAmbiguous = false,
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

  /// Whether to include strict special characters (quotes, backslash, angle
  /// brackets, pipe, braces) that some backends may reject.
  final bool includeSpecialStrict;

  /// Whether to exclude visually ambiguous characters (0/O, 1/l/I) that are
  /// easy to confuse when reading or retyping a password.
  final bool excludeAmbiguous;

  /// The raw character set for a category, independent of [excludeAmbiguous].
  static String rawCharacters(PasswordCategory category) {
    switch (category) {
      case PasswordCategory.uppercase:
        return AppConstants.uppercaseCharacters;
      case PasswordCategory.lowercase:
        return AppConstants.lowercaseCharacters;
      case PasswordCategory.numbers:
        return AppConstants.numberCharacters;
      case PasswordCategory.special:
        return AppConstants.specialCharacters;
      case PasswordCategory.specialStrict:
        return AppConstants.strictSpecialCharacters;
    }
  }

  static final RegExp _ambiguousPattern =
      RegExp('[${AppConstants.ambiguousCharacters}]');

  /// The effective character pool for [category], honoring [excludeAmbiguous].
  String getPool(PasswordCategory category) {
    final raw = rawCharacters(category);
    if (!excludeAmbiguous) return raw;
    return raw.replaceAll(_ambiguousPattern, '');
  }

  /// Returns the number of currently active character categories.
  int get activeCategoriesCount {
    int count = 0;
    if (includeUppercase) count++;
    if (includeLowercase) count++;
    if (includeNumbers) count++;
    if (includeSpecial) count++;
    if (includeSpecialStrict) count++;
    return count;
  }

  /// Calculates the total character pool size (R) based on active categories.
  ///
  /// When [excludeAmbiguous] is enabled, the ambiguous characters are removed
  /// from the pool sizes so the displayed entropy stays honest.
  int get totalPoolSize {
    int poolSize = 0;
    for (final category in PasswordCategory.values) {
      if (isCategoryEnabled(category)) {
        poolSize += getPool(category).length;
      }
    }
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
      case PasswordCategory.specialStrict:
        return includeSpecialStrict;
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
    bool? includeSpecialStrict,
    bool? excludeAmbiguous,
  }) {
    return PasswordConfig(
      length: length ?? this.length,
      includeUppercase: includeUppercase ?? this.includeUppercase,
      includeLowercase: includeLowercase ?? this.includeLowercase,
      includeNumbers: includeNumbers ?? this.includeNumbers,
      includeSpecial: includeSpecial ?? this.includeSpecial,
      includeSpecialStrict:
          includeSpecialStrict ?? this.includeSpecialStrict,
      excludeAmbiguous: excludeAmbiguous ?? this.excludeAmbiguous,
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
          includeSpecial == other.includeSpecial &&
          includeSpecialStrict == other.includeSpecialStrict &&
          excludeAmbiguous == other.excludeAmbiguous;

  @override
  int get hashCode => Object.hash(
        length,
        includeUppercase,
        includeLowercase,
        includeNumbers,
        includeSpecial,
        includeSpecialStrict,
        excludeAmbiguous,
      );

  @override
  String toString() {
    return 'PasswordConfig(length: $length, uppercase: $includeUppercase, '
        'lowercase: $includeLowercase, numbers: $includeNumbers, '
        'special: $includeSpecial, strictSpecial: $includeSpecialStrict, '
        'excludeAmbiguous: $excludeAmbiguous)';
  }
}
