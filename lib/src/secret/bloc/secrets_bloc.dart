import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lokr_ui/src/secret/bloc/secrets_event.dart';
import 'package:lokr_ui/src/secret/bloc/secrets_state.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/resources/secret_repository.dart';

class SecretsBloc extends Bloc<SecretsEvent, SecretsState> {
  SecretsBloc() : super(Initial());

  @override
  Stream<SecretsState> mapEventToState(SecretsEvent event) async* {
    if (event is LoadAllFromCache) yield* this._mapLoadAllFromCache();
    if (event is SaveSingleToCache) yield* this._mapSaveSingleToCache(event);
    if (event is DeleteSingleFromCache)
      yield* this._mapDeleteSingleFromCache(event);
    if (event is UpdateSingleFromCache)
      yield* this._mapUpdateSingleFromCache(event);
    if (event is SyncWithAPI)
      yield* this._mapSyncWithAPI(event);
  }

  Stream<SecretsState> _mapUpdateSingleFromCache(
      UpdateSingleFromCache event) async* {
    try {
      await SecretRepository.update(event.secret);
    } catch (e) {
      addError(e, StackTrace.current);
      yield DeleteSingleFromCacheError(secrets: this.state.secrets, error: e.toString());
    }

    yield* _mapLoadAllFromCache();
  }

  Stream<SecretsState> _mapDeleteSingleFromCache(
      DeleteSingleFromCache event) async* {
    try {
      await SecretRepository.delete(event.secret);
    } catch (e) {
      addError(e, StackTrace.current);
      yield DeleteSingleFromCacheError(secrets: this.state.secrets, error: e.toString());
    }

    yield* _mapLoadAllFromCache();
  }

  Stream<SecretsState> _mapSaveSingleToCache(SaveSingleToCache event) async* {
    try {
      await SecretRepository.save(event.secret);
    } catch (e) {
      addError(e, StackTrace.current);
      yield SaveSingleToCacheError(secrets: this.state.secrets, error: e.toString());
    }

    yield SaveSingleToCacheSuccess(await SecretRepository.findAll());
  }

  Stream<SecretsState> _mapLoadAllFromCache() async* {
    List<Secret> fetchedSecrets;
    try {
      fetchedSecrets = await SecretRepository.findAll();
    } catch (e) {
      yield LoadAllFromCacheError(secrets: this.state.secrets, error: e.toString());
      addError(e, StackTrace.current);
    }

    yield LoadAllFromCacheSuccess(fetchedSecrets);
  }

  @override
  void onTransition(Transition<SecretsEvent, SecretsState> transition) {
    print('Transition event $transition');
    super.onTransition(transition);
  }

  Stream<SecretsState> _mapSyncWithAPI(SyncWithAPI event) async* {
    //TODO: implement correct behaviour
    yield* _mapLoadAllFromCache();
  }
}
