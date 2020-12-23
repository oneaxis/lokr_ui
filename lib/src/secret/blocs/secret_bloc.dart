import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/resources/secret_repository.dart';
import 'package:rxdart/rxdart.dart';

class SecretBloc {
  final _secretsSubject = PublishSubject<List<Secret>>();

  Stream<List<Secret>> get allSecrets => _secretsSubject.stream;

  fetchAllSecrets() async {
    List<Secret> secrets = await SecretRepository.fetchAllSecrets();
    _secretsSubject.sink.add(secrets);
  }

  dispose() {
    _secretsSubject.close();
  }
}