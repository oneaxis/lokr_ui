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

class SecretsErrorState extends SecretsState {
  final String error;

  SecretsErrorState(List<Secret> secrets, this.error) : super(secrets);
}

class SecretsFetchAllSuccess extends SecretsState {
  SecretsFetchAllSuccess(List<Secret> secrets) : super(secrets);
}

class SecretsStoreSingleError extends SecretsErrorState {
  SecretsStoreSingleError(List<Secret> secrets, String error)
      : super(secrets, error);
}

class SecretsUpdatedSingleError extends SecretsErrorState {
  SecretsUpdatedSingleError(List<Secret> secrets, String error)
      : super(secrets, error);
}

class SecretsDeleteSingleError extends SecretsErrorState {
  SecretsDeleteSingleError(List<Secret> secrets, String error)
      : super(secrets, error);
}

class SecretsFetchAllError extends SecretsErrorState {
  SecretsFetchAllError(List<Secret> secrets, String error)
      : super(secrets, error);
}
