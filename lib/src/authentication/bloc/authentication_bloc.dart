import 'package:bloc/bloc.dart';
import 'package:lokr_ui/src/authentication/bloc/authentication_event.dart';

import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(AuthenticationState initialState) : super(initialState);

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is LogIn)
      yield* mapLogInToState(event);
    else if (event is LogOut) yield* mapLogOutToState(event);
  }

  Stream<AuthenticationState> mapLogInToState(LogIn event) async* {
    try {

    } catch (error) {
      yield LogInError(event.principal, error);
    }
  }

  Stream<AuthenticationState> mapLogOutToState(LogOut event) {}
}
