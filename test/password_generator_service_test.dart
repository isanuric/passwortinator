import 'package:flutter_test/flutter_test.dart';
import 'package:passwortinator/src/core/constants/app_constants.dart';
import 'package:passwortinator/src/features/password_generator/logic/password_generator_service.dart';
import 'package:passwortinator/src/features/password_generator/models/password_config.dart';

void main() {
  group('PasswordGeneratorService', () {
    late PasswordGeneratorService service;

    setUp(() {
      service = const PasswordGeneratorService();
    });

    test('calculates correct entropy based on active pools', () {
      // 1. All default categories active (strict off): Pool = 26 + 26 + 10 + 16 = 78.
      // E = 16 * log2(78) ≈ 100.57 bits
      const allActiveConfig = PasswordConfig(length: 16);
      final entropyAll = service.calculateEntropy(allActiveConfig);
      expect(entropyAll, closeTo(100.57, 0.05));

      // 2. All categories including strict active: Pool = 78 + 16 = 94.
      // E = 16 * log2(94) ≈ 104.87 bits
      const allStrictConfig = PasswordConfig(
        length: 16,
        includeSpecialStrict: true,
      );
      final entropyStrict = service.calculateEntropy(allStrictConfig);
      expect(entropyStrict, closeTo(104.87, 0.05));

      // 3. Only lowercase active: Pool = 26.
      // E = 8 * log2(26) ≈ 8 * 4.70044 = 37.60 bits (< 50 => Weak)
      const lowercaseOnlyConfig = PasswordConfig(
        length: 8,
        includeUppercase: false,
        includeLowercase: true,
        includeNumbers: false,
        includeSpecial: false,
      );
      final entropyLower = service.calculateEntropy(lowercaseOnlyConfig);
      expect(entropyLower, closeTo(37.60, 0.05));

      // 4. Lowercase + Uppercase: Pool = 52.
      // E = 10 * log2(52) ≈ 10 * 5.70044 = 57.00 bits (50 <= E < 70 => Medium)
      const upperLowerConfig = PasswordConfig(
        length: 10,
        includeUppercase: true,
        includeLowercase: true,
        includeNumbers: false,
        includeSpecial: false,
      );
      final entropyUpperLower = service.calculateEntropy(upperLowerConfig);
      expect(entropyUpperLower, closeTo(57.00, 0.05));
    });

    test('generates password with exact requested length', () {
      for (final length in [8, 12, 16, 24, 32, 64]) {
        final config = PasswordConfig(length: length);
        final password = service.generatePassword(config);
        expect(password.length, equals(length));
      }
    });

    test('guarantees at least one character from each active category', () {
      const config = PasswordConfig(
        length: 16,
        includeUppercase: true,
        includeLowercase: true,
        includeNumbers: true,
        includeSpecial: true,
        includeSpecialStrict: true,
      );

      final upperRegex = RegExp(r'[A-Z]');
      final lowerRegex = RegExp(r'[a-z]');
      final numberRegex = RegExp(r'[0-9]');
      final specialSet = AppConstants.specialCharacters.split('').toSet();
      final strictSet = AppConstants.strictSpecialCharacters.split('').toSet();

      for (int i = 0; i < 100; i++) {
        final password = service.generatePassword(config);
        expect(password.length, equals(16));
        expect(upperRegex.hasMatch(password), isTrue,
            reason: 'Password must contain uppercase');
        expect(lowerRegex.hasMatch(password), isTrue,
            reason: 'Password must contain lowercase');
        expect(numberRegex.hasMatch(password), isTrue,
            reason: 'Password must contain numbers');
        expect(
          password.split('').any((c) => specialSet.contains(c)),
          isTrue,
          reason: 'Password must contain special characters',
        );
        expect(
          password.split('').any((c) => strictSet.contains(c)),
          isTrue,
          reason: 'Password must contain strict special characters',
        );
      }
    });

    test('contains only characters from enabled categories', () {
      // Only numbers
      const numbersOnly = PasswordConfig(
        length: 20,
        includeUppercase: false,
        includeLowercase: false,
        includeNumbers: true,
        includeSpecial: false,
      );

      final numberRegex = RegExp(r'^[0-9]+$');
      for (int i = 0; i < 20; i++) {
        final password = service.generatePassword(numbersOnly);
        expect(numberRegex.hasMatch(password), isTrue);
      }
    });

    test('throws ArgumentError when length is smaller than active categories',
        () {
      // 5 categories active, but only 3 characters requested.
      const tooShort = PasswordConfig(
        length: 3,
        includeUppercase: true,
        includeLowercase: true,
        includeNumbers: true,
        includeSpecial: true,
        includeSpecialStrict: true,
      );

      expect(
        () => service.generatePassword(tooShort),
        throwsArgumentError,
      );

      // Exactly matching length is allowed and yields that exact length.
      const exact = PasswordConfig(
        length: 5,
        includeUppercase: true,
        includeLowercase: true,
        includeNumbers: true,
        includeSpecial: true,
        includeSpecialStrict: true,
      );
      expect(service.generatePassword(exact).length, equals(5));
    });

    test('excludes ambiguous characters when configured', () {
      const config = PasswordConfig(
        length: 20,
        excludeAmbiguous: true,
      );

      final ambiguous = RegExp('[${AppConstants.ambiguousCharacters}]');
      for (int i = 0; i < 50; i++) {
        final password = service.generatePassword(config);
        expect(password.length, equals(20));
        expect(ambiguous.hasMatch(password), isFalse,
            reason: 'Password must not contain 0/O/1/l/I with exclusion on');
      }
    });

    test('entropy reflects smaller pools when ambiguous chars are excluded',
        () {
      // Default pools: 26 + 26 + 10 + 16 = 78
      // With ambiguous exclusion: 24 + 24 + 8 + 16 = 72
      const config = PasswordConfig(
        length: 16,
        excludeAmbiguous: true,
      );
      expect(config.totalPoolSize, equals(72));

      // E = 16 * log2(72) ≈ 98.72 bits (less than 100.57 without exclusion).
      final entropy = service.calculateEntropy(config);
      expect(entropy, closeTo(98.72, 0.05));
    });

    test('generates unique passwords across multiple invocations', () {
      const config = PasswordConfig(length: 16);
      final set = <String>{};

      for (int i = 0; i < 50; i++) {
        set.add(service.generatePassword(config));
      }

      // With 16 characters from the 78-char pool, all 50 should be unique
      expect(set.length, equals(50));
    });
  });
}
