import 'package:lokr_ui/src/authentication/domain/bouncer.dart';
import 'package:lokr_ui/src/encryption/encryption_wrapper.dart';
import 'package:lokr_ui/src/repository.dart';

import '../../encryption_storage_provider.dart';

class BouncersRepository extends Repository<Bouncer> {
  final repositoryTable = DatabaseTables.bouncers;

  @override
  Future<void> delete(Bouncer instance) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<bool> exists(Bouncer instance) {
    // TODO: implement exists
    throw UnimplementedError();
  }

  @override
  Future<Bouncer> find(Bouncer instance) async {
    final databaseBouncer =
        await this.storageProvider.read(instance, repositoryTable);

    if (databaseBouncer == null) throw Exception('No Bouncer has been found!');

    return Bouncer.fromJson(databaseBouncer);
  }

  @override
  Future<List<Bouncer>> findAll() {
    // TODO: implement findAll
    throw UnimplementedError();
  }

  @override
  Future<void> save(Bouncer instance) async {
    await this.storageProvider.insert(instance, repositoryTable);
  }

  @override
  Future<void> saveAll(List<Bouncer> instances) {
    // TODO: implement saveAll
    throw UnimplementedError();
  }

  Future<Bouncer> findLastActiveEncrypted() async {
    List<EncryptionWrapper> activeBouncers = await this
        .storageProvider
        .readEncrypted(
            where: null,
            whereArgs: null,
            orderBy: 'updatedAt DESC',
            table: repositoryTable);

    if (activeBouncers == null || activeBouncers.isEmpty)
      throw Exception('No bouncer found!');

    return Bouncer(activeBouncers.first.id, null);
  }
}
