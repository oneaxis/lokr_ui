import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lokr_ui/src/secret/bloc/secrets_event.dart';
import 'package:lokr_ui/src/secret/bloc/secrets_state.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/resources/secret_repository.dart';

class SecretsBloc extends Bloc<SecretsEvent, SecretsState> {
  SecretsBloc() : super(SecretsInitial());

  @override
  Stream<SecretsState> mapEventToState(SecretsEvent event) async* {
    if (event is SecretsFetchAll) yield* this._mapFetchAllToState();
    if (event is SecretsStoreSingle)
      yield* this._mapStoreSingleWithState(event);
    if (event is SecretsDeleteSingle)
      yield* this._mapDeleteSingleWithState(event);
    if (event is SecretsUpdateSingle)
      yield* this._mapUpdateSingleWithState(event);
  }

  Stream<SecretsState> _mapUpdateSingleWithState(
      SecretsUpdateSingle event) async* {
    try {
      await SecretsRepository.updateSecret(event.secret);
    } catch (e) {
      addError(e, StackTrace.current);
      yield SecretsDeleteSingleError(this.state.secrets, e);
    }

    yield* _mapFetchAllToState();
  }

  Stream<SecretsState> _mapDeleteSingleWithState(
      SecretsDeleteSingle event) async* {
    try {
      await SecretsRepository.deleteSecret(event.secret);
    } catch (e) {
      addError(e, StackTrace.current);
      yield SecretsDeleteSingleError(this.state.secrets, e);
    }

    yield* _mapFetchAllToState();
  }

  Stream<SecretsState> _mapStoreSingleWithState(
      SecretsStoreSingle event) async* {
    try {
      await SecretsRepository.storeSecret(event.secret);
    } catch (e) {
      addError(e, StackTrace.current);
      yield SecretsStoreSingleError(this.state.secrets, e);
    }

    yield* _mapFetchAllToState();
  }

  Stream<SecretsState> _mapFetchAllToState() async* {
    List<Secret> fetchedSecrets;
    try {
      fetchedSecrets = await SecretsRepository.fetchAllSecrets();
    } catch (e) {
      addError(e, StackTrace.current);
      yield SecretsFetchAllError(this.state.secrets, e);
    }

    yield SecretsFetchAllSuccess(fetchedSecrets);
  }

  @override
  void onTransition(Transition<SecretsEvent, SecretsState> transition) {
    print('Transition event $transition');
    super.onTransition(transition);
  }
}
