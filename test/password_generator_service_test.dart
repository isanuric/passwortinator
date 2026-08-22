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
      // 1. All categories active: Pool = 26 + 26 + 10 + 32 = 94.
      // E = 16 * log2(94) = 16 * (ln(94) / ln(2)) ≈ 104.873 bits
      const allActiveConfig = PasswordConfig(length: 16);
      final entropyAll = service.calculateEntropy(allActiveConfig);
      expect(entropyAll, closeTo(104.87, 0.05));

      // 2. Only lowercase active: Pool = 26.
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

      // 3. Lowercase + Uppercase: Pool = 52.
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
      );

      final upperRegex = RegExp(r'[A-Z]');
      final lowerRegex = RegExp(r'[a-z]');
      final numberRegex = RegExp(r'[0-9]');
      final specialSet = AppConstants.specialCharacters.split('').toSet();

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

    test('generates unique passwords across multiple invocations', () {
      const config = PasswordConfig(length: 16);
      final set = <String>{};

      for (int i = 0; i < 50; i++) {
        set.add(service.generatePassword(config));
      }

      // With 16 characters from 94 pool, all 50 should be unique
      expect(set.length, equals(50));
    });
  });
}
