import 'package:lokr_ui/src/authentication/domain/user.dart';
import 'package:lokr_ui/src/repository.dart';
import 'package:lokr_ui/src/storage_provider.dart';

/// Storage provider for application database and initializer for secrets table.
/// To run create an instance (singleton) and initialize it:
/// `SecretStorageProvider().init();`
class UsersRepository extends Repository<User> {
  final _repositoryTable = DatabaseTables.users;

  @override
  Future<void> delete(User instance) async {
    await this.storageProvider.delete(
          instance,
          _repositoryTable,
        );
  }

  @override
  Future<User> find(User instance) async {

    List<User> users = await findAll();

    return users.where((user) => instance.username == user.username).first;
  }

  @override
  Future<List<User>> findAll() async {
    return (await this.storageProvider.readAll(_repositoryTable))
        .map((decryptedInstance) => User.fromJson(decryptedInstance))
        .toList();
  }

  @override
  Future<void> save(User instance) async {
    await this.storageProvider.insert(instance, _repositoryTable);
  }

  @override
  Future<void> saveAll(List<User> instances) => throw UnimplementedError();
}
