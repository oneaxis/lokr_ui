class AuthenticationEvent {
  AuthenticationEvent();
}

class LogOut extends AuthenticationEvent {}

class CreateBouncer extends AuthenticationEvent {
  String masterPassword;

  CreateBouncer(this.masterPassword) : super();
}

class LogIn extends AuthenticationEvent {
  String masterPassword;

  LogIn(this.masterPassword) : super();
}

class CheckBouncerExistence extends AuthenticationEvent {}
