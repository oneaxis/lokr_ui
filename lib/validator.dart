import 'package:lokr_ui/secret.dart';

class Validator {
  bool isValid(Secret secret) {
    if (secret.url != null && !_isValidURL(secret.url)) return false;
    if (secret.username != null && !_isValidUsername(secret.username))
      return false;

    return _isValidPassword(secret.password) && _isValidTitle(secret.title);
  }

  bool _isValidURL(String url) {
    return url.isNotEmpty;
  }

  bool _isValidPassword(String password) {
    return password.isNotEmpty;
  }

  bool _isValidUsername(String username) {
    return username.isNotEmpty;
  }

  bool _isValidTitle(String title) {
    return title.isNotEmpty;
  }
}
