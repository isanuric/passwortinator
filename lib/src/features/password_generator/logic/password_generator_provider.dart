import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../models/password_config.dart';
import '../models/password_strength.dart';
import 'password_generator_service.dart';
import 'password_generator_state.dart';

/// Provider exposing the [PasswordGeneratorService] instance.
final passwordGeneratorServiceProvider = Provider<PasswordGeneratorService>((ref) {
  return const PasswordGeneratorService();
});

/// Riverpod notifier managing password generation state and actions.
class PasswordGeneratorNotifier extends Notifier<PasswordGeneratorState> {
  late final PasswordGeneratorService _service;

  @override
  PasswordGeneratorState build() {
    _service = ref.watch(passwordGeneratorServiceProvider);
    const initialConfig = PasswordConfig();
    return _computeState(initialConfig);
  }

  /// Updates the desired password length and regenerates the password.
  void setLength(int newLength) {
    final clampedLength = newLength.clamp(
      AppConstants.minPasswordLength,
      AppConstants.maxPasswordLength,
    );
    if (state.config.length == clampedLength) return;

    final updatedConfig = state.config.copyWith(length: clampedLength);
    state = _computeState(updatedConfig);
  }

  /// Toggles a character category on or off.
  ///
  /// Prevents turning off the last remaining active category.
  void toggleCategory(PasswordCategory category, bool isEnabled) {
    if (!isEnabled && !state.config.canDisableCategory(category)) {
      // Cannot disable the last active category
      return;
    }

    PasswordConfig updatedConfig;
    switch (category) {
      case PasswordCategory.uppercase:
        updatedConfig = state.config.copyWith(includeUppercase: isEnabled);
        break;
      case PasswordCategory.lowercase:
        updatedConfig = state.config.copyWith(includeLowercase: isEnabled);
        break;
      case PasswordCategory.numbers:
        updatedConfig = state.config.copyWith(includeNumbers: isEnabled);
        break;
      case PasswordCategory.special:
        updatedConfig = state.config.copyWith(includeSpecial: isEnabled);
        break;
    }

    state = _computeState(updatedConfig);
  }

  /// Manually triggers generation of a new password with the existing configuration.
  void regenerate() {
    state = _computeState(state.config);
  }

  /// Helper to compute full state from a given config.
  PasswordGeneratorState _computeState(PasswordConfig config) {
    final entropy = _service.calculateEntropy(config);
    final strength = PasswordStrength.fromEntropy(entropy);
    final password = _service.generatePassword(config);

    return PasswordGeneratorState(
      config: config,
      password: password,
      entropy: entropy,
      strength: strength,
    );
  }
}

/// Main state notifier provider for the password generator feature.
final passwordGeneratorProvider =
    NotifierProvider<PasswordGeneratorNotifier, PasswordGeneratorState>(
  PasswordGeneratorNotifier.new,
);
