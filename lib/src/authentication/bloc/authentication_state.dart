import 'package:flutter/foundation.dart';
import 'package:lokr_ui/src/authentication/domain/user.dart';

class AuthenticationState {
  final User principal;

  AuthenticationState(this.principal);
}

class AuthenticationErrorState extends AuthenticationState {
  final String error;

  AuthenticationErrorState(User principal, this.error) : super(principal);
}

class LogInSuccess extends AuthenticationState {
  LogInSuccess(User principal) : super(principal);
}

class LogInError extends AuthenticationErrorState {
  LogInError(User principal, String error) : super(principal, error);
}

class LogOutSuccess extends AuthenticationState {
  LogOutSuccess(User principal) : super(principal);
}

class LogOutError extends AuthenticationErrorState {
  LogOutError(User principal, String error) : super(principal, error);
}
