import 'package:flutter/foundation.dart';
import 'package:lokr_ui/src/authentication/domain/user.dart';

class AuthenticationEvent {
  final User user;

  AuthenticationEvent(this.user);
}

class LogOut extends AuthenticationEvent {
  LogOut(User user) : super(user);
}

class Registration extends AuthenticationEvent {
  Registration({@required String username, @required String password})
      : super(User.create(username: username, password: password));
}

class LogIn extends AuthenticationEvent {
  LogIn(User user) : super(user);
}
