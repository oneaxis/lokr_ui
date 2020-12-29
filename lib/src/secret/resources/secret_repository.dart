import 'dart:convert';

import 'package:lokr_ui/src/secret/domain/secret.dart';

import 'secret_storage.dart';

class SecretRepository {
  static const String secretDatasetKey = 'secrets';

  static Future<List<Secret>> saveAll(List<Secret> secrets) async {
    String encodedSecretList = jsonEncode(secrets);
    await SecretStorage.write(key: secretDatasetKey, value: encodedSecretList);
    return secrets;
  }

  static Future<List<Secret>> findAll() async {
    String encodedSecretList = (await SecretStorage.read(key: secretDatasetKey))??jsonEncode(List.empty());
    List<dynamic> decodedSecretList = jsonDecode(encodedSecretList)
        .map((event) => Secret.fromJson(event))
        .toList();

    return List<Secret>.from(decodedSecretList);
  }

  static Future<Secret> save(Secret secret) async {
    List<Secret> secrets = await findAll();
    secrets.add(secret);
    await saveAll(secrets);
    return secret;
  }

  static Future<Secret> delete(Secret secret) {
    throw 'Not implemented yet!';
  }

  static Future<Secret> update(Secret secret) {
    throw 'Not implemented yet!';
  }
}
