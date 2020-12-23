import 'dart:math';

class SecretGenerator {
  /// Use this method to generate a password based on a provided set of Options.
  /// @param options Options. If not set, DefaultOptions will be used.
  static Future<String> generateRandomPassword({Options options}) {
    return Future(() =>
        SecretGenerator()._generateRandomPassword(options: options));
  }

  String _generateRandomPassword({Options options}) {
    final GeneratorPolicy generatorPolicy =
    this._evaluateOptions(options ?? DefaultOptions());

    String result = '';
    int charactersLength = generatorPolicy.characterSet.length;
    while (result.length < generatorPolicy.length ||
        !this._isValidAgainstPolicy(result, generatorPolicy)) {
      String charToInsert = generatorPolicy
          .characterSet[Random.secure().nextInt(charactersLength - 1)];

      if (result.length == generatorPolicy.length){
        result =
            _replaceCharAt(result, Random.secure().nextInt(result.length - 1), charToInsert);
      } else {
        result += generatorPolicy
            .characterSet[Random.secure().nextInt(charactersLength - 1)];
      }
    }

    return result;
  }

  String _replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar +
        oldString.substring(index + 1);
  }

  GeneratorPolicy _evaluateOptions(Options options) {
    final List<CharacterSet> evaluatedCharacterSets = [];

    if (options.full) {
      options.uppercase = true;
      options.lowercase = true;
      options.special = true;
      options.numeric = true;
    }

    if (options.uppercase) {
      evaluatedCharacterSets.add(CharacterSet.uppercase);
    }

    if (options.lowercase) {
      evaluatedCharacterSets.add(CharacterSet.lowercase);
    }

    if (options.special) {
      evaluatedCharacterSets.add(CharacterSet.special);
    }

    if (options.numeric) {
      evaluatedCharacterSets.add(CharacterSet.numeric);
    }

    if (evaluatedCharacterSets.length > options.length && options.strict) {
      const errorMessage = 'Couldn\'t apply mode strict whenever the ' +
          'amount of selected character sets is higher than the actual password length!';
      throw new Exception(errorMessage);
    }

    String evaluatedCharacters = '';
    for (CharacterSet charSet in evaluatedCharacterSets) {
      evaluatedCharacters += charSet.value;
    }

    return GeneratorPolicy(
        length: options.length,
        characterSet: evaluatedCharacters,
        requiredCharacterSets: evaluatedCharacterSets,
        strict: options.strict);
  }

  bool _isValidAgainstPolicy(String password, GeneratorPolicy policy) {
    if (!policy.strict) {
      return true;
    }

    bool allCharSetsContained = true;
    for (final CharacterSet charSet in policy.requiredCharacterSets) {
      bool charSetContained = false;
      for (final String character in charSet.value.split('')) {
        if (password.indexOf(character) > -1) {
          charSetContained = true;
          break;
        }
      }

      if (!charSetContained) {
        allCharSetsContained = false;
        break;
      }
    }

    return allCharSetsContained;
  }
}

class GeneratorPolicy {
  final int length;
  final List<CharacterSet> requiredCharacterSets;
  final String characterSet;
  final bool strict;

  const GeneratorPolicy({this.length,
    this.requiredCharacterSets,
    this.characterSet,
    this.strict});
}

class Options {
  /// Password length
  int length;

  /// Use only full characters and avoid characters with semantic meaning in diffent contexts
  bool full;

  /// Use lowercase characters
  bool lowercase;

  /// Use uppercase characters
  bool uppercase;

  /// Use special characters
  bool special;

  /// Use numeric characters
  bool numeric;

  /// At least one character of each set needs to be contained
  bool strict;
}

class DefaultOptions implements Options {
  @override
  bool full = true;

  @override
  int length = 15;

  @override
  bool lowercase = true;

  @override
  bool uppercase = true;

  @override
  bool numeric = true;

  @override
  bool special = true;

  @override
  bool strict = true;
}

enum CharacterSet { uppercase, lowercase, special, numeric }

extension CharacterSetExension on CharacterSet {
  String get value {
    switch (this) {
      case CharacterSet.uppercase:
        return 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      case CharacterSet.lowercase:
        return 'abcdefghijklmnopqrstuvwxyz';
      case CharacterSet.special:
        return r'@#$%';
      case CharacterSet.numeric:
        return '0123456789';
      default:
        return null;
    }
  }
}
