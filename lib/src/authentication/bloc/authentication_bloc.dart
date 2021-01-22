import 'package:bloc/bloc.dart';
import 'package:lokr_ui/src/authentication/bloc/authentication_event.dart';
import 'package:lokr_ui/src/authentication/domain/bouncer.dart';
import 'package:lokr_ui/src/secret/resources/secret_repository.dart';
import 'package:lokr_ui/src/storage_provider.dart';

import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(Initial());

  final _secretsRepository = SecretsRepository();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is CheckBouncerExistence)
      yield* mapCheckBounderExistenceToState(event);
    if (event is LogIn)
      yield* mapLogInToState(event);
    else if (event is CreateBouncer)
      yield* mapCreateBouncerToState(event);
    else if (event is LogOut) yield* mapLogOutToState(event);
  }

  Stream<AuthenticationState> mapCheckBounderExistenceToState(
      CheckBouncerExistence event) async* {
    try {
      final bouncerExists = await _secretsRepository.exists(
        Bouncer(null),
      );

      yield bouncerExists
          ? BouncerFound()
          : throw Exception('Bouncer not found');
    } catch (error) {
      yield BouncerNotFound(error.toString());
    }
  }

  Stream<AuthenticationState> mapLogInToState(LogIn event) async* {
    try {
      await EncryptionStorageProvider().initialize(event.masterPassword);

      final bouncer = await _secretsRepository.find(
        Bouncer(event.masterPassword),
      );

      yield bouncer != null
          ? LogInSuccess(bouncer)
          : throw Exception('Bouncer not found');
    } catch (error) {
      yield LogInError(error.toString());
    }
  }

  Stream<AuthenticationState> mapLogOutToState(LogOut event) {}

  Stream<AuthenticationState> mapCreateBouncerToState(
      CreateBouncer event) async* {
    try {
      final bouncer = Bouncer(event.masterPassword);
      await EncryptionStorageProvider().initialize(event.masterPassword);

      await _secretsRepository.save(bouncer);

      yield LogInSuccess(bouncer);
    } catch (error) {
      yield CreateBouncerError(error.toString());
    }
  }
}
