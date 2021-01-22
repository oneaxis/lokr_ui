import 'package:lokr_ui/src/authentication/domain/bouncer.dart';

class AuthenticationState {
  final Bouncer bouncer;

  AuthenticationState(this.bouncer);
}

class Initial extends AuthenticationState {
  Initial() : super(null);
}

class AuthenticationErrorState extends AuthenticationState {
  final String error;

  AuthenticationErrorState(Bouncer bouncer, this.error) : super(bouncer);
}

class LogInSuccess extends AuthenticationState {
  LogInSuccess(Bouncer bouncer) : super(bouncer);
}

class LogInError extends AuthenticationErrorState {
  LogInError(String error) : super(null, error);
}

class BouncerNotFound extends AuthenticationErrorState {
  BouncerNotFound(String error) : super(null, error);
}

class BouncerFound extends AuthenticationState {
  BouncerFound() : super(null);
}

class CreateBouncerError extends AuthenticationErrorState {
  CreateBouncerError(String error) : super(null, error);
}

class LogOutSuccess extends AuthenticationState {
  LogOutSuccess(Bouncer bouncer) : super(bouncer);
}

class LogOutError extends AuthenticationErrorState {
  LogOutError(String error) : super(null, error);
}
