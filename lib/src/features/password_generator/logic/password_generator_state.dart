import 'package:flutter/foundation.dart';
import '../models/password_config.dart';
import '../models/password_strength.dart';

/// Represents the UI and domain state of the password generator.
@immutable
class PasswordGeneratorState {
  const PasswordGeneratorState({
    required this.config,
    required this.password,
    required this.entropy,
    required this.strength,
  });

  /// The active configuration settings.
  final PasswordConfig config;

  /// The currently generated password string.
  final String password;

  /// The calculated entropy of the password in bits.
  final double entropy;

  /// The mapped strength level (Weak, Medium, Strong).
  final PasswordStrength strength;

  /// Creates a copy of this state with optional updated values.
  PasswordGeneratorState copyWith({
    PasswordConfig? config,
    String? password,
    double? entropy,
    PasswordStrength? strength,
  }) {
    return PasswordGeneratorState(
      config: config ?? this.config,
      password: password ?? this.password,
      entropy: entropy ?? this.entropy,
      strength: strength ?? this.strength,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordGeneratorState &&
          runtimeType == other.runtimeType &&
          config == other.config &&
          password == other.password &&
          entropy == other.entropy &&
          strength == other.strength;

  @override
  int get hashCode => Object.hash(config, password, entropy, strength);

  @override
  String toString() =>
      'PasswordGeneratorState(config: $config, password: [length ${password.length}], '
      'entropy: ${entropy.toStringAsFixed(1)}, strength: ${strength.label})';
}
