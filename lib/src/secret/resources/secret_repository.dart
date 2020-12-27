import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/resources/secret_api_service.dart';

class SecretsRepository {
  static Future<List<Secret>> fetchAllSecrets() {
    return SecretAPIService.fetchAllSecrets();
  }

  static Future<Secret> storeSecret(Secret secret) {
    return SecretAPIService.storeSecret(secret);
  }

  static Future<Secret> updateSecret(Secret secret) {
    return SecretAPIService.updateSecret(secret);
  }

  static Future<Secret> deleteSecret(Secret secret) {
    return SecretAPIService.deleteSecret(secret);
  }
}
