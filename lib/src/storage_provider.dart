import 'package:lokr_ui/src/encryption/encryptable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'encryption/decryptor.dart';
import 'encryption/encryption_wrapper.dart';
import 'encryption/encryptor.dart';

/// Convention to follow: Nothing goes in or out without passing encryption.
class EncryptionStorageProvider {
  final databaseFileName = 'lokr_database.db';
  Database _database;

  static final EncryptionStorageProvider _singleton =
      EncryptionStorageProvider._internal();

  factory EncryptionStorageProvider() {
    return _singleton;
  }

  Future<void> initialize() async {
    this._database = await openDatabase(
      join(await getDatabasesPath(), databaseFileName),
      onCreate: (db, version) {
        return db.execute(_getCreateTablesSQL());
      },
      version: 4,
    );

    print('Database initialized ' + _database.path);
  }

  EncryptionStorageProvider._internal();

  String _getCreateTablesSQL() {
    List<String> createTableSQLs = [
      'CREATE TABLE ${DatabaseTables.users.name}(id TEXT PRIMARY KEY, encryptedContent TEXT)',
      'CREATE TABLE ${DatabaseTables.secrets.name}(id TEXT PRIMARY KEY, encryptedContent TEXT)'
    ];

    return createTableSQLs.join('; ');
  }

  Future<void> insertAll(
      final List<Encryptable> encryptables, final DatabaseTables table) async {
    throw UnimplementedError();
  }

  Future<void> insert(
      final Encryptable encryptable, final DatabaseTables table) async {
    final EncryptionWrapper wrapper = Encryptor.encrypt(encryptable);

    await _database.insert(
      table.name,
      wrapper.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(
      Encryptable encryptable, final DatabaseTables table) async {
    await _database.delete(
      table.name,
      where: 'id = ?',
      whereArgs: [encryptable.id],
    );
  }

  Future<Map<String, dynamic>> read(
      final Encryptable encryptable, final DatabaseTables table) async {
    return (await _database.query(table.name,
            where: 'id = ?',
            whereArgs: [encryptable.id]))
        .map((queryResult) => EncryptionWrapper.fromJson(queryResult))
        .map((wrapper) => Decryptor.decrypt(wrapper))
        .first;
  }

  Future<List<Map<String, dynamic>>> readAll(final DatabaseTables table) async {
    return (await _database.query(table.name))
        .map((queryResult) => EncryptionWrapper.fromJson(queryResult))
        .map((wrapper) => Decryptor.decrypt(wrapper))
        .toList();
  }
}

enum DatabaseTables { users, secrets }

extension DatabaseTableNames on DatabaseTables {
  get name {
    switch (this) {
      case DatabaseTables.secrets:
        return 'secrets';
      case DatabaseTables.users:
        return 'users';
    }
  }
}
