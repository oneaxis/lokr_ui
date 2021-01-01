import 'dart:convert';

import 'package:lokr_ui/src/encryption/encryption_wrapper.dart';

class Decryptor {
  static dynamic decrypt(EncryptionWrapper encryptionWrapper) {
    var encryptable = _decryptContent(encryptionWrapper);
    encryptable['id'] = encryptionWrapper.id;

    return encryptable;
  }

  static dynamic _decryptContent(EncryptionWrapper encryptionWrapper) {
    return jsonDecode(encryptionWrapper.encryptedContent);
  }
}
