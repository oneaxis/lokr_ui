import 'dart:convert';

import 'package:lokr_ui/src/encryption/encryptable.dart';
import 'package:lokr_ui/src/encryption/encryption_wrapper.dart';

class Encryptor {
  static EncryptionWrapper encrypt(Encryptable encryptable) {
    var wrapperId = _prepare(encryptable);
    var wrapperContent = _encryptContent(encryptable);

    return EncryptionWrapper(encryptedContent: wrapperContent, id: wrapperId);
  }

  static String _encryptContent(Encryptable encryptable) {
    if (encryptable.id != null) throw Exception(
        'Encryptable still contains an id. Extract it to avoid leaking encrypted content');

    return jsonEncode(encryptable);
  }

  static String _prepare(Encryptable encryptable) {
    // Extract id to avoid leaking encrypted content
    var id = encryptable.id;
    encryptable.id = null;
    return id;
  }
}
