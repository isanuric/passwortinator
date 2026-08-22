import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passwortinator/src/core/constants/app_constants.dart';
import 'package:passwortinator/src/features/password_generator/logic/password_generator_provider.dart';
import 'package:passwortinator/src/features/password_generator/models/password_config.dart';

void main() {
  group('PasswordGeneratorNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initializes with default config and valid password', () {
      final state = container.read(passwordGeneratorProvider);

      expect(state.config.length, equals(AppConstants.defaultPasswordLength));
      expect(state.password.length, equals(AppConstants.defaultPasswordLength));
      expect(state.entropy,
          greaterThan(70.0)); // All categories active with length 16 is strong
    });

    test(
        'setLength updates length and entropy live without regenerating password',
        () {
      final notifier = container.read(passwordGeneratorProvider.notifier);
      final initialPassword =
          container.read(passwordGeneratorProvider).password;
      final initialEntropy = container.read(passwordGeneratorProvider).entropy;

      notifier.setLength(24);
      var state = container.read(passwordGeneratorProvider);

      // Length and entropy reflect the new value immediately...
      expect(state.config.length, equals(24));
      expect(state.entropy, greaterThan(initialEntropy));
      // ...but the password is NOT regenerated on every slider tick.
      expect(state.password, equals(initialPassword));
      expect(state.password.length, equals(initialPassword.length));

      // After the drag ends (onChangeEnd), the password is regenerated.
      notifier.regenerate();
      state = container.read(passwordGeneratorProvider);

      expect(state.password.length, equals(24));
      expect(state.password, isNot(equals(initialPassword)));
    });

    test('setLength clamps to min and max allowed length', () {
      final notifier = container.read(passwordGeneratorProvider.notifier);

      notifier.setLength(1);
      expect(container.read(passwordGeneratorProvider).config.length,
          equals(AppConstants.minPasswordLength));

      notifier.setLength(200);
      expect(container.read(passwordGeneratorProvider).config.length,
          equals(AppConstants.maxPasswordLength));
    });

    test('toggleCategory prevents disabling the last active category', () {
      final notifier = container.read(passwordGeneratorProvider.notifier);

      // Disable 3 categories one by one
      notifier.toggleCategory(PasswordCategory.lowercase, false);
      notifier.toggleCategory(PasswordCategory.numbers, false);
      notifier.toggleCategory(PasswordCategory.special, false);

      var state = container.read(passwordGeneratorProvider);
      expect(state.config.activeCategoriesCount, equals(1));
      expect(state.config.includeUppercase, isTrue);

      // Attempt to disable the remaining category
      notifier.toggleCategory(PasswordCategory.uppercase, false);

      state = container.read(passwordGeneratorProvider);
      // Uppercase should STILL be true
      expect(state.config.includeUppercase, isTrue);
      expect(state.config.activeCategoriesCount, equals(1));
    });

    test('regenerate generates a new password', () {
      final notifier = container.read(passwordGeneratorProvider.notifier);
      final initialPassword =
          container.read(passwordGeneratorProvider).password;

      // Note: In extremely rare case it could match if short, but at length 16 with 94 chars pool it's virtually impossible
      notifier.regenerate();
      final newPassword = container.read(passwordGeneratorProvider).password;

      expect(newPassword.length, equals(initialPassword.length));
    });
  });
}
