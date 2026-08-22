import 'dart:math' as math;
import '../models/password_config.dart';

/// Cryptographically secure service for generating passwords and calculating entropy.
class PasswordGeneratorService {
  const PasswordGeneratorService({math.Random? random}) : _random = random;

  final math.Random? _random;

  math.Random get _secureRandom => _random ?? math.Random.secure();

  /// Calculates the information entropy (in bits) of a password configuration.
  ///
  /// Mathematical formula:
  /// ```
  /// E = L * log2(R)
  /// ```
  /// where:
  /// - `L` = password length
  /// - `R` = size of the active character pool
  double calculateEntropy(PasswordConfig config) {
    final int poolSize = config.totalPoolSize;
    if (config.length <= 0 || poolSize <= 0) {
      return 0.0;
    }
    // log2(R) = ln(R) / ln(2)
    return config.length * (math.log(poolSize) / math.ln2);
  }

  /// Generates a cryptographically secure password based on the provided [config].
  ///
  /// Guarantee logic:
  /// 1. Exactly one character is drawn from each enabled category first.
  /// 2. The remaining characters are drawn uniformly from the combined active pool.
  /// 3. The entire character array is shuffled securely before returning.
  ///
  /// Throws [ArgumentError] if [config.length] is smaller than the number of
  /// active categories – in that case the exact length cannot be guaranteed
  /// while still including every enabled character set.
  String generatePassword(PasswordConfig config) {
    final int activeCategories = config.activeCategoriesCount;
    if (config.length < activeCategories) {
      throw ArgumentError(
        'Password length (${config.length}) must be at least the number of '
        'active categories ($activeCategories) to guarantee one character '
        'per category.',
      );
    }

    final random = _secureRandom;
    final List<String> guaranteedCharacters = [];
    final StringBuffer combinedPool = StringBuffer();

    // 1. Guarantee logic: Draw exactly one random character per active category
    for (final category in PasswordCategory.values) {
      if (!config.isCategoryEnabled(category)) continue;
      final pool = config.getPool(category);
      guaranteedCharacters.add(_getRandomChar(pool, random));
      combinedPool.write(pool);
    }

    final String poolString = combinedPool.toString();
    if (poolString.isEmpty) {
      return '';
    }

    final List<String> resultCharacters =
        List<String>.from(guaranteedCharacters);

    // 2. Fill the remaining length from the combined pool
    final int remainingLength = config.length - guaranteedCharacters.length;
    for (int i = 0; i < remainingLength; i++) {
      resultCharacters.add(_getRandomChar(poolString, random));
    }

    // 3. Cryptographically secure shuffle of all characters
    resultCharacters.shuffle(random);

    return resultCharacters.join('');
  }

  /// Helper to pick a single random character from a non-empty string.
  String _getRandomChar(String source, math.Random random) {
    final int index = random.nextInt(source.length);
    return source[index];
  }
}
