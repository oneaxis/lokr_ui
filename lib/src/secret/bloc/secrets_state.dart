import 'package:flutter/foundation.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';

abstract class SecretsState {
  final List<Secret> secrets;

  SecretsState(this.secrets);
}

abstract class SecretStateSingle extends SecretsState {
  final Secret subject;

  SecretStateSingle({this.subject, List<Secret> secrets}) : super(secrets);
}

abstract class SecretsErrorState extends SecretsState {
  final List<Secret> secrets;
  final String error;

  SecretsErrorState(this.secrets, this.error) : super(secrets);
}

abstract class SecretStateSingleError extends SecretsErrorState {
  final String error;
  final Secret subject;

  SecretStateSingleError({this.subject, List<Secret> secrets, this.error})
      : super(secrets, error);
}

class Initial extends SecretsState {
  Initial() : super(List<Secret>.empty());
}

class LoadAllFromCacheSuccess extends SecretsState {
  LoadAllFromCacheSuccess(List<Secret> secrets) : super(secrets);
}

class LoadAllFromCacheError extends SecretsErrorState {
  LoadAllFromCacheError({List<Secret> secrets, String error})
      : super(secrets, error);
}

class SaveSingleToCacheSuccess extends SecretsState {
  SaveSingleToCacheSuccess(List<Secret> secrets) : super(secrets);
}

class SaveSingleToCacheError extends SecretsErrorState {
  SaveSingleToCacheError({List<Secret> secrets, String error})
      : super(secrets, error);
}

class UpdateSingleFromCacheSuccess extends SecretsState {
  UpdateSingleFromCacheSuccess(List<Secret> secrets) : super(secrets);
}

class UpdateSingleFromCacheError extends SecretsErrorState {
  UpdateSingleFromCacheError({List<Secret> secrets, String error})
      : super(secrets, error);
}

class DeleteSingleFromCacheSuccess extends SecretsState {
  DeleteSingleFromCacheSuccess(List<Secret> secrets) : super(secrets);
}

class DeleteSingleFromCacheError extends SecretsErrorState {
  DeleteSingleFromCacheError({List<Secret> secrets, String error})
      : super(secrets, error);
}

class SyncWithAPISuccess extends SecretsState {
  SyncWithAPISuccess(List<Secret> secrets) : super(secrets);
}

class SyncWithAPIError extends SecretsErrorState {
  SyncWithAPIError({List<Secret> secrets, String error})
      : super(secrets, error);
}
