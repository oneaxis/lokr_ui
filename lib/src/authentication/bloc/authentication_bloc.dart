import 'package:bloc/bloc.dart';
import 'package:lokr_ui/src/authentication/bloc/authentication_event.dart';
import 'package:lokr_ui/src/authentication/domain/user.dart';
import 'package:lokr_ui/src/authentication/resources/users_repository.dart';

import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(Initial());

  final UsersRepository _usersRepository = UsersRepository();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is LogIn)
      yield* mapLogInToState(event);
    else if (event is Registration)
      yield* mapRegistrationToState(event);
    else if (event is LogOut) yield* mapLogOutToState(event);
  }

  Stream<AuthenticationState> mapLogInToState(LogIn event) async* {
    try {
      final User user = await _usersRepository.find(event.user);

      yield user != null
          ? LogInSuccess(event.user)
          : throw Exception('User not found');
    } catch (error) {
      yield LogInError(event.user, error);
    }
  }

  Stream<AuthenticationState> mapLogOutToState(LogOut event) {}

  Stream<AuthenticationState> mapRegistrationToState(
      Registration event) async* {
    try {
      await _usersRepository.save(event.user);
      yield RegistrationSuccess(event.user);
    } catch (error) {
      yield RegistrationError(event.user, error);
    }
  }
}
