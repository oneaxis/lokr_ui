import 'package:lokr_ui/src/authentication/domain/user.dart';

class AuthenticationEvent {
  final User principal;

  AuthenticationEvent(this.principal);
}

class LogOut extends AuthenticationEvent {
  LogOut(User principal) : super(principal);
}

class LogIn extends AuthenticationEvent {
  LogIn(User principal) : super(principal);
}
