import 'package:flutter_test/flutter_test.dart';
import 'package:passwortinator/src/features/password_generator/models/password_strength.dart';

void main() {
  group('PasswordStrength', () {
    test('maps entropy to weak (< 50 bit)', () {
      expect(PasswordStrength.fromEntropy(0.0), equals(PasswordStrength.weak));
      expect(PasswordStrength.fromEntropy(49.9), equals(PasswordStrength.weak));
      expect(PasswordStrength.weak.label, equals('Weak'));
    });

    test('maps entropy to medium (50 <= E < 70 bit)', () {
      expect(
          PasswordStrength.fromEntropy(50.0), equals(PasswordStrength.medium));
      expect(
          PasswordStrength.fromEntropy(65.4), equals(PasswordStrength.medium));
      expect(
          PasswordStrength.fromEntropy(69.9), equals(PasswordStrength.medium));
      expect(PasswordStrength.medium.label, equals('Medium'));
    });

    test('maps entropy to strong (>= 70 bit)', () {
      expect(
          PasswordStrength.fromEntropy(70.0), equals(PasswordStrength.strong));
      expect(
          PasswordStrength.fromEntropy(104.8), equals(PasswordStrength.strong));
      expect(PasswordStrength.strong.label, equals('Strong'));
    });
  });
}
