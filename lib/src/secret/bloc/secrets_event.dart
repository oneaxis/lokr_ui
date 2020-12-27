import 'package:equatable/equatable.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';

abstract class SecretsEvent extends Equatable {
  const SecretsEvent();

  @override
  List<Object> get props => [];
}

class SecretsFetchAll extends SecretsEvent {}

class SecretsDeleteSingle extends SecretsEvent {
  final Secret _secret;

  SecretsDeleteSingle(this._secret);

  Secret get secret => _secret;

  @override
  List<Object> get props => [this._secret];
}

class SecretsUpdateSingle extends SecretsEvent {
  final Secret _secret;

  SecretsUpdateSingle(this._secret);

  Secret get secret => _secret;

  @override
  List<Object> get props => [this._secret];
}

class SecretsStoreSingle extends SecretsEvent {
  final Secret _secret;

  SecretsStoreSingle(this._secret);

  Secret get secret => _secret;

  @override
  List<Object> get props => [this._secret];
}
