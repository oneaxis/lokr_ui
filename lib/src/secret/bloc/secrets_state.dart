import 'package:flutter/foundation.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';

abstract class SecretsState {
  final List<Secret> secrets;

  SecretsState(this.secrets);
}

abstract class SecretStateSingleSuccess extends SecretsState {
  final Secret subject;

  SecretStateSingleSuccess({this.subject, List<Secret> secrets}) : super(secrets);
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

class SaveSingleToCacheSuccess extends SecretStateSingleSuccess {
  SaveSingleToCacheSuccess({Secret subject, List<Secret> secrets}) : super(subject: subject, secrets: secrets);
}

class SaveSingleToCacheError extends SecretsErrorState {
  SaveSingleToCacheError({List<Secret> secrets, String error})
      : super(secrets, error);
}

class DeleteSingleFromCacheSuccess extends SecretStateSingleSuccess {
  DeleteSingleFromCacheSuccess({Secret subject, List<Secret> secrets}) : super(subject: subject, secrets: secrets);
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
