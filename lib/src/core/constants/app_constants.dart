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

  /// Common special characters that are widely accepted across systems (16).
  ///
  /// These symbols rarely cause issues in password fields, URLs, SQL or shell
  /// environments and are safe to use almost anywhere.
  static const String specialCharacters = r'!@#$%^&*()_-+=?~';

  /// Strict special characters that some backends reject or mangle (16).
  ///
  /// Quotes, backslash, backtick, angle brackets, pipe and braces can trigger
  /// escaping problems or validation failures in certain legacy or strict
  /// systems (SAP, banking, shells, HTML/XML forms). They are off by default
  /// and can be enabled explicitly when broad compatibility is not required.
  static const String strictSpecialCharacters = r'''"'`\,./:;<>|{}[]''';

  /// Character pool sizes for entropy calculation.
  static const int lowercasePoolSize = 26;
  static const int uppercasePoolSize = 26;
  static const int numberPoolSize = 10;
  static const int specialPoolSize = 16;
  static const int strictSpecialPoolSize = 16;

  /// Characters that look alike and are frequently confused when typing or
  /// reading a password (0/O, 1/l/I). Excluding them is an option in
  /// professional generators (1Password, Bitwarden, KeePass) to make
  /// passwords easier to read aloud and retype.
  static const String ambiguousCharacters = 'IOlo10';

  /// Number of ambiguous characters removed from each pool when the
  /// `excludeAmbiguous` option is enabled.
  static const int ambiguousUppercaseCount = 2; // I, O
  static const int ambiguousLowercaseCount = 2; // l, o
  static const int ambiguousNumberCount = 2; // 1, 0

  /// Entropy thresholds in bits.
  static const double weakThreshold = 50.0;
  static const double strongThreshold = 70.0;
}
