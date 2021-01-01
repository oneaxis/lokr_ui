import 'package:lokr_ui/src/encryption/decryptor.dart';
import 'package:lokr_ui/src/encryption/encryption_wrapper.dart';
import 'package:lokr_ui/src/encryption/encryptor.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Storage provider for application database and initializer for secrets table.
/// To run create an instance (singleton) and initialize it:
/// `SecretStorageProvider().init();`
class SecretStorageProvider {
  final String secretsTableName = 'secrets',
      databaseFileName = 'lokr_database.db',
      createSecretsTableSQL =
          'CREATE TABLE secrets(id TEXT PRIMARY KEY, encryptedContent TEXT)';
  Database database;
  static final SecretStorageProvider _singleton =
      SecretStorageProvider._internal();

  factory SecretStorageProvider() {
    return _singleton;
  }

  Future<void> init() async {
    this.database = await openDatabase(
      join(await getDatabasesPath(), databaseFileName),
      onCreate: (db, version) {
        return db.execute(createSecretsTableSQL);
      },
      version: 1,
    );

    print('Database initialized ' + database.path);
  }

  SecretStorageProvider._internal();

  Future<void> insert(Secret secret) async {
    final EncryptionWrapper wrapper = Encryptor.encrypt(secret);

    await database.insert(
      secretsTableName,
      wrapper.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(Secret secret) async {
    await database.delete(
      secretsTableName,
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [secret.id],
    );
  }

  Future<List<Secret>> read() async {
    final List parsedSecrets = (await database.query(secretsTableName))
        .map((queryResult) => EncryptionWrapper.fromJson(queryResult))
        .map((wrapper) => Decryptor.decrypt(wrapper))
        .map((encryptable) => Secret.fromJson(encryptable))
        .toList();

    return parsedSecrets;
  }
}
