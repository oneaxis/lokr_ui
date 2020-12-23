import 'dart:convert';

import 'package:lokr_ui/src/encryption_wrapper.dart';
import 'package:http/http.dart' as http;
import 'package:lokr_ui/src/secret/domain/secret.dart';

class SecretAPIService {
  static final String _apiServer = 'http://192.168.178.23:1234';
  static final SecretAPIService _instance = SecretAPIService._internal();

  factory SecretAPIService() => _instance;

  SecretAPIService._internal();

  static Future<Secret> storeSecret(Secret secret) async {
    final response =
        await http.post('$_apiServer/api/secrets/', body: secret.toJson());

    if (response.statusCode == 201) {
      var decodedResponse = jsonDecode(response.body);
      EncryptionWrapper wrapper = EncryptionWrapper.fromJson(decodedResponse);
      return Secret.fromJson(wrapper.content);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw 'Failed to store secret!';
    }
  }

  static Future<List<Secret>> fetchAllSecrets() async {
    final response = await http.get('$_apiServer/api/secrets/');

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      List<dynamic> parsedSecrets = decodedResponse
          .map((json) => EncryptionWrapper.fromJson(json))
          .map((wrapper) => Secret.fromJson(wrapper.content))
          .toList();

      return List<Secret>.from(parsedSecrets);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw 'Failed to load stored secrets!';
    }
  }
}
