import 'package:bloc/bloc.dart';
import 'package:lokr_ui/src/authentication/bloc/bouncer_events.dart';
import 'package:lokr_ui/src/authentication/domain/bouncer.dart';
import 'package:lokr_ui/src/authentication/resources/bouncers_repository.dart';
import 'package:lokr_ui/src/secret/resources/secret_repository.dart';
import 'package:lokr_ui/src/encryption_storage_provider.dart';

import 'bouncer_states.dart';

class AuthenticationBloc extends Bloc<BouncerEvent, BouncerState> {
  AuthenticationBloc() : super(Initial());

  final _bouncersRepository = BouncersRepository();

  @override
  Stream<BouncerState> mapEventToState(BouncerEvent event) async* {
    if (event is GetLastActiveBouncer)
      yield* mapGetLastActiveBouncerToState(event);
    if (event is HireBouncer)
      yield* mapHireBouncerToState(event);
    else if (event is TellMasterPassword)
      yield* mapTellMasterPasswordToState(event);
  }

  Stream<BouncerState> mapGetLastActiveBouncerToState(
      GetLastActiveBouncer event) async* {
    try {
      final lastActiveBouncer =
          await _bouncersRepository.findLastActiveEncrypted();

      yield BouncerReady(lastActiveBouncer);
    } catch (error) {
      yield BouncerNotFound(error.toString());
    }
  }

//
  Stream<BouncerState> mapTellMasterPasswordToState(
      TellMasterPassword event) async* {
    try {
      await EncryptionStorageProvider()
          .setEncryptionPassword(event.masterPassword);

      final bouncer = await _bouncersRepository.find(
        state.bouncer,
      );

      yield BouncerAcceptedMasterPassword(bouncer);
    } catch (error) {
      yield BouncerRejectedMasterPassword(state.bouncer, error.toString());
    }
  }

//
// Stream<BouncerState> mapLogOutToState(LogOut event) {}
//
  Stream<BouncerState> mapHireBouncerToState(HireBouncer event) async* {
    try {
      final bouncer = event.bouncer;
      await EncryptionStorageProvider()
          .setEncryptionPassword(bouncer.masterPassword);

      await _bouncersRepository.save(bouncer);

      yield BouncerAcceptedMasterPassword(bouncer);
    } catch (error) {
      yield CreateBouncerError(error.toString());
    }
  }
}
