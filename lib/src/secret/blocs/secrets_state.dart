import 'package:equatable/equatable.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';

abstract class SecretsState extends Equatable {
  final List<Secret> _secrets;

  const SecretsState(this._secrets);

  @override
  List<Object> get props => [this._secrets];

  List<Secret> get secrets => this._secrets;
}

class SecretsInitial extends SecretsState {
  SecretsInitial() : super(List.empty());
}

class SecretsFetchedAll extends SecretsState {
  SecretsFetchedAll(List<Secret> secrets) : super(secrets);
}

class SecretsUpdatedSingle extends SecretsState {
  SecretsUpdatedSingle(List<Secret> secrets) : super(secrets);
}

class SecretsDeletedSingle extends SecretsState {
  SecretsDeletedSingle(List<Secret> secrets) : super(secrets);
}

class SecretsAddedSingle extends SecretsState {
  SecretsAddedSingle(List<Secret> secrets) : super(secrets);
}

class SecretsFetchedWithError extends SecretsState {
  SecretsFetchedWithError(List<Secret> secrets) : super(secrets);
}
