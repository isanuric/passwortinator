import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../models/password_config.dart';
import '../models/password_strength.dart';
import 'password_generator_service.dart';
import 'password_generator_state.dart';

/// Provider exposing the [PasswordGeneratorService] instance.
final passwordGeneratorServiceProvider =
    Provider<PasswordGeneratorService>((ref) {
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

  /// Live-updates the length preview while the user drags the slider.
  ///
  /// Only the length, entropy and strength are recalculated (cheap math).
  /// The password itself is intentionally NOT regenerated here to avoid
  /// repeatedly invoking the costly system CSPRNG with every slider tick.
  /// It is regenerated once via [regenerate] when the drag ends.
  void setLength(int newLength) {
    final clampedLength = newLength.clamp(
      AppConstants.minPasswordLength,
      AppConstants.maxPasswordLength,
    );
    if (state.config.length == clampedLength) return;

    final updatedConfig = state.config.copyWith(length: clampedLength);
    state = _computeState(updatedConfig, generatePassword: false);
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
      case PasswordCategory.specialStrict:
        updatedConfig = state.config.copyWith(includeSpecialStrict: isEnabled);
        break;
    }

    state = _computeState(updatedConfig);
  }

  /// Manually triggers generation of a new password with the existing
  /// configuration (uses the current config, including the latest length).
  void regenerate() {
    state = _computeState(state.config);
  }

  /// Helper to compute full state from a given config.
  ///
  /// When [generatePassword] is false (slider drag preview),
  /// [PasswordGeneratorState.password] is kept from the previous state and
  /// only the cheap metadata (entropy + strength) is recomputed.
  PasswordGeneratorState _computeState(
    PasswordConfig config, {
    bool generatePassword = true,
  }) {
    final entropy = _service.calculateEntropy(config);
    final strength = PasswordStrength.fromEntropy(entropy);
    final password =
        generatePassword ? _service.generatePassword(config) : state.password;

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
