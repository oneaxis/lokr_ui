import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lokr_ui/src/secret/bloc/secrets_event.dart';
import 'package:lokr_ui/src/secret/bloc/secrets_state.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/resources/secret_repository.dart';

class SecretsBloc extends Bloc<SecretsEvent, SecretsState> {
  final SecretsRepository repository = SecretsRepository();

  SecretsBloc() : super(Initial());

  @override
  Stream<SecretsState> mapEventToState(SecretsEvent event) async* {
    if (event is LoadAllFromCache) yield* this._mapLoadAllFromCache();
    if (event is SaveSingleToCache) yield* this._mapSaveSingleToCache(event);
    if (event is DeleteSingleFromCache)
      yield* this._mapDeleteSingleFromCache(event);
    if (event is SaveAllToCache) yield* this._mapSaveAllToCache(event);
    if (event is SyncWithAPI) yield* this._mapSyncWithAPI(event);
  }

  Stream<SecretsState> _mapDeleteSingleFromCache(
      DeleteSingleFromCache event) async* {
    try {
      await repository.delete(event.secret);
      yield DeleteSingleFromCacheSuccess(
          subject: event.secret, secrets: await repository.findAll());
    } catch (error) {
      yield DeleteSingleFromCacheError(
          secrets: this.state.secrets, error: error.toString());
    }

  }

  Stream<SecretsState> _mapSaveSingleToCache(SaveSingleToCache event) async* {
    try {
      await repository.save(event.secret);
      yield SaveSingleToCacheSuccess(
          subject: event.secret, secrets: await repository.findAll());
    } catch (error) {
      yield SaveSingleToCacheError(
          secrets: await repository.findAll(), error: error.toString());
    }
  }

  Stream<SecretsState> _mapSaveAllToCache(SaveAllToCache event) async* {
    try {
      await repository.saveAll(event.secrets);
      yield SaveAllToCacheSuccess(await repository.findAll());
    } catch (error) {
      yield SaveAllToCacheError(
          secrets: await repository.findAll(), error: error.toString());
    }
  }

  Stream<SecretsState> _mapLoadAllFromCache() async* {
    List<Secret> fetchedSecrets;
    try {
      fetchedSecrets = await repository.findAll();
      yield LoadAllFromCacheSuccess(fetchedSecrets);
    } catch (error) {
      yield LoadAllFromCacheError(
          secrets: this.state.secrets, error: error.toString());
    }
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
