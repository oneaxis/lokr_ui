import 'package:lokr_ui/src/authentication/domain/user.dart';
import 'package:lokr_ui/src/repository.dart';
import 'package:lokr_ui/src/storage_provider.dart';

/// Storage provider for application database and initializer for secrets table.
/// To run create an instance (singleton) and initialize it:
/// `SecretStorageProvider().init();`
class UsersRepository extends Repository<User> {
  final repositoryTable = DatabaseTables.users;

  @override
  Future<void> delete(User instance) async {
    await this.storageProvider.delete(
          instance,
          repositoryTable,
        );
  }

  @override
  Future<User> find(User instance) async {
    return User.fromJson(
        (await this.storageProvider.read(instance, repositoryTable)));
  }

  @override
  Future<List<User>> findAll() async {
    return (await this.storageProvider.readAll(repositoryTable))
        .map((decryptedInstance) => User.fromJson(decryptedInstance))
        .toList();
  }

  @override
  Future<void> save(User instance) async {
    await this.storageProvider.insert(instance, repositoryTable);
  }

  @override
  Future<void> saveAll(List<User> instances) {
    // TODO: implement saveAll
    throw UnimplementedError();
  }
}
