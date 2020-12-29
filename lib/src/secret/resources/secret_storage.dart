import 'package:flutter/cupertino.dart';

class SecretStorage {
  static final Map<String, String> _deviceStorage = {};

  static Future<String> read({@required String key}) async {
    return _deviceStorage[key];
  }

  static Future write({@required String key, @required String value}) async {
    _deviceStorage[key] = value;
  }
}
