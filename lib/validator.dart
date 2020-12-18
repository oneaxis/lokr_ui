import 'package:lokr_ui/secret.dart';

class Validator {
  static String required(String value) {
    return value.isEmpty ? 'Required! Provide a valid value' : null;
  }
}
