import 'package:lokr_ui/src/repository.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/storage_provider.dart';

class SecretsRepository extends Repository<Secret> {
  final repositoryTable = DatabaseTables.secrets;

  @override
  Future<void> delete(Secret instance) async {
    await this.storageProvider.delete(
          instance,
          repositoryTable,
        );
  }

  @override
  Future<Secret> find(Secret instance) async {
    final databaseSecret =
        await this.storageProvider.read(instance, repositoryTable);

    if (databaseSecret == null) throw Exception('No Secret has been found!');

    return Secret.fromJson((databaseSecret));
  }

  @override
  Future<List<Secret>> findAll() async {

    final databaseSecrets = await this.storageProvider.readAll(repositoryTable);

    if (databaseSecrets == null) throw Exception('No Secret has been found!');

    return (databaseSecrets)
        .map((decryptedInstance) => Secret.fromJson(decryptedInstance))
        .toList();
  }

  @override
  Future<void> save(Secret instance) async {
    await this.storageProvider.insert(instance, repositoryTable);
  }

  @override
  Future<void> saveAll(List<Secret> instances) {
    // TODO: implement saveAll
    throw UnimplementedError();
  }

  @override
  Future<bool> exists(Secret instance) async {
    await this.storageProvider.exists(instance.id, repositoryTable);
  }
}
