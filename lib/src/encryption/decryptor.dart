import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:lokr_ui/src/encryption/encryption_wrapper.dart';
import 'package:password_hash/password_hash.dart';

class Decryptor {
  static Map<String, dynamic> decrypt(EncryptionWrapper encryptionWrapper) {
    dynamic decrypted = _decryptContent(encryptionWrapper);
    decrypted['id'] = encryptionWrapper.id;

    return decrypted;
  }

  static dynamic _decryptContent(EncryptionWrapper encryptionWrapper) {
    var generator = PBKDF2();
    var salt = 'e5cb2c72-4c58-11eb-ae93-0242ac130002';
    var passwordHash =
        generator.generateBase64Key("mytopsecretpassword", salt, 1000, 32);
    final key = Key.fromBase64(passwordHash); // TODO: pass over from login

    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    return jsonDecode(
        encrypter.decrypt64(encryptionWrapper.encryptedContent, iv: iv));
  }
}
