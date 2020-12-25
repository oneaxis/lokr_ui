import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lokr_ui/src/secret/blocs/secrets_event.dart';
import 'package:lokr_ui/src/secret/blocs/secrets_state.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/resources/secret_repository.dart';

class SecretsBloc extends Bloc<SecretsEvent, SecretsState> {
  SecretsBloc() : super(SecretsInitial());

  @override
  Stream<SecretsState> mapEventToState(SecretsEvent event) async* {
    if (event is SecretsFetchAll) yield* this._mapFetchAllToState();
  }

  Stream<SecretsState> _mapFetchAllToState() async* {
    List<Secret> fetchedSecrets;
    try {
      fetchedSecrets = await SecretsRepository.fetchAllSecrets();
    } catch (e) {
      addError(e, StackTrace.current);
      yield SecretsFetchedWithError(this.state.secrets);
    }

    yield SecretsFetchedAll(fetchedSecrets);
  }

  @override
  void onTransition(Transition<SecretsEvent, SecretsState> transition) {
    print('Transition event $transition');
    super.onTransition(transition);
  }
}
