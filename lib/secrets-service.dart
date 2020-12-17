import 'dart:convert';

import 'package:lokr_ui/encryption-wrapper.dart';
import 'package:lokr_ui/messaging-service.dart';
import 'package:lokr_ui/secret.dart';
import 'package:http/http.dart' as http;

class SecretsService {
  final String apiServer = 'http://192.168.178.23:1234';
  static final SecretsService _instance = SecretsService._internal();

  factory SecretsService() => _instance;

  SecretsService._internal();

  Future<List<Secret>> getAllSecrets() async {
    final response = await http.get('$apiServer/api/secrets/');

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
      throw Exception('Failed to load stored secrets!');
    }
  }
}
