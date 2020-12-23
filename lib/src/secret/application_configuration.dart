import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApplicationConfiguration {
  static String get apiURL => getFromDotEnv('apiURL');
  static String get secretsEndpoint => getFromDotEnv('secretsEndpoint');

  static String getFromDotEnv(String key) {
    String value = DotEnv().env[key];
    return value == null || value.isEmpty
        ? throw Exception('Parameter \'$key\' has not been set in .env.local')
        : value;
  }
}