import 'package:flutter_test/flutter_test.dart';
import 'package:passwortinator/src/features/password_generator/models/password_config.dart';

void main() {
  group('PasswordConfig', () {
    test('default configuration has all options enabled and length 16', () {
      const config = PasswordConfig();
      expect(config.length, equals(16));
      expect(config.includeUppercase, isTrue);
      expect(config.includeLowercase, isTrue);
      expect(config.includeNumbers, isTrue);
      expect(config.includeSpecial, isTrue);
      expect(config.activeCategoriesCount, equals(4));
      expect(config.totalPoolSize, equals(94)); // 26 + 26 + 10 + 32
    });

    test('validates single active category cannot be disabled', () {
      const singleActiveConfig = PasswordConfig(
        includeUppercase: true,
        includeLowercase: false,
        includeNumbers: false,
        includeSpecial: false,
      );

      expect(singleActiveConfig.activeCategoriesCount, equals(1));
      expect(singleActiveConfig.canDisableCategory(PasswordCategory.uppercase), isFalse);
      expect(singleActiveConfig.canDisableCategory(PasswordCategory.lowercase), isTrue);
    });

    test('allows disabling when multiple categories are active', () {
      const multipleActiveConfig = PasswordConfig(
        includeUppercase: true,
        includeLowercase: true,
        includeNumbers: false,
        includeSpecial: false,
      );

      expect(multipleActiveConfig.activeCategoriesCount, equals(2));
      expect(multipleActiveConfig.canDisableCategory(PasswordCategory.uppercase), isTrue);
      expect(multipleActiveConfig.canDisableCategory(PasswordCategory.lowercase), isTrue);
    });
  });
}
