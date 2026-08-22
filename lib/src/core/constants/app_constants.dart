/// Application-wide constants for password generation and configuration.
class AppConstants {
  AppConstants._();

  /// Default password length on app start.
  static const int defaultPasswordLength = 16;

  /// Minimum allowed password length.
  static const int minPasswordLength = 8;

  /// Maximum allowed password length.
  static const int maxPasswordLength = 64;

  /// Lowercase alphabet characters (26 characters).
  static const String lowercaseCharacters = 'abcdefghijklmnopqrstuvwxyz';

  /// Uppercase alphabet characters (26 characters).
  static const String uppercaseCharacters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// Numeric digit characters (10 characters).
  static const String numberCharacters = '0123456789';

  /// Standard ASCII special characters (32 characters).
  static const String specialCharacters =
      r'''!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~''';

  /// Character pool sizes for entropy calculation.
  static const int lowercasePoolSize = 26;
  static const int uppercasePoolSize = 26;
  static const int numberPoolSize = 10;
  static const int specialPoolSize = 32;

  /// Entropy thresholds in bits.
  static const double weakThreshold = 50.0;
  static const double strongThreshold = 70.0;
}
