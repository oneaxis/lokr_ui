import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/resources/secret_api_service.dart';

class SecretRepository {
  static Future<List<Secret>> fetchAllSecrets() {
    return SecretAPIService.fetchAllSecrets();
  }

  static Future<Secret> storeSecret(Secret secret) {
    return SecretAPIService.storeSecret(secret);
  }
}