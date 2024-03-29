import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:lokr_ui/src/encryption/encryptable.dart';
import 'package:lokr_ui/src/encryption/encryption_wrapper.dart';
import 'package:password_hash/password_hash.dart';

class Encryptor {
  static EncryptionWrapper encrypt(
      String encryptionPassword, Encryptable encryptable) {
    var encryptedContent =
        _encryptContent(encryptionPassword, jsonEncode(encryptable));

    return EncryptionWrapper(
        encryptedContent: encryptedContent, id: encryptable.id);
  }

  static String _encryptContent(
      String encryptionPassword, String encryptableContent) {
    var generator = PBKDF2();
    var salt = 'e5cb2c72-4c58-11eb-ae93-0242ac130002';
    var passwordHash =
        generator.generateBase64Key(encryptionPassword, salt, 1000, 32);
    final key = Key.fromBase64(passwordHash);

    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    return encrypter.encrypt(encryptableContent, iv: iv).base64;
  }
}
