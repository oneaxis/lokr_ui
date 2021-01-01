import 'dart:convert';

import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/resources/secret_storage_provider.dart';

class SecretRepository {
  static final SecretStorageProvider _secretStorage = SecretStorageProvider();

  static Future<void> saveAll(List<Secret> secrets) async {
    for (Secret secret in secrets) {
      await _secretStorage.insert(secret);
    }
    return secrets;
  }

  static Future<List<Secret>> findAll() async {
    List<Secret> storedSecrets = (await _secretStorage.read()) ?? List.empty();

    return List<Secret>.from(storedSecrets);
  }

  static Future<void> save(Secret secret) async {
    return _secretStorage.insert(secret);
  }

  static Future<void> delete(Secret secret) {
    return _secretStorage.delete(secret);
  }
}
