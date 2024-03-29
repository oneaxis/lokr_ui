import 'package:lokr_ui/src/secret/domain/secret.dart';

abstract class SecretsEvent {}

abstract class SecretsEventSingleSecret extends SecretsEvent {
  final Secret secret;

  SecretsEventSingleSecret(this.secret) : super();
}

class LoadAllFromCache extends SecretsEvent {}

class SaveAllToCache extends SecretsEvent {
  final List<Secret> secrets;

  SaveAllToCache(this.secrets);
}

class SaveSingleToCache extends SecretsEventSingleSecret {
  SaveSingleToCache(Secret secret) : super(secret);
}

class DeleteSingleFromCache extends SecretsEventSingleSecret {
  DeleteSingleFromCache(Secret secret) : super(secret);
}

class SyncWithAPI extends SecretsEvent {}
