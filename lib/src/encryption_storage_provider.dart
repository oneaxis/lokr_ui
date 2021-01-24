import 'package:lokr_ui/src/encryption/encryptable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'encryption/decryptor.dart';
import 'encryption/encryption_wrapper.dart';
import 'encryption/encryptor.dart';

/// Convention to follow: Nothing goes in or out without passing encryption.
class EncryptionStorageProvider {
  final databaseFileName = 'lokr_database.db';
  String _encryptionPassword;
  Database _database;

  static final EncryptionStorageProvider _singleton =
      EncryptionStorageProvider._internal();

  factory EncryptionStorageProvider() {
    return _singleton;
  }

  Future<void> setEncryptionPassword(String encryptionPassword) {
    this._encryptionPassword = encryptionPassword;
  }

  Future<void> initialize() async {
    this._database = await openDatabase(
      join(await getDatabasesPath(), databaseFileName),
      onCreate: (db, version) {
        _getCreateTableStatements()
            .forEach((statement) => db.execute(statement));
      },
      version: 12,
    );

    print('Database initialized ' + _database.path);
  }

  EncryptionStorageProvider._internal();

  List _getCreateTableStatements() {
    List<String> createTableSQLs = [
      'CREATE TABLE ${DatabaseTables.bouncers.name}(id TEXT PRIMARY KEY, updatedAt TEXT, createdAt TEXT, encryptedContent TEXT)',
      'CREATE TABLE ${DatabaseTables.secrets.name}(id TEXT PRIMARY KEY, updatedAt TEXT, createdAt TEXT, encryptedContent TEXT)',
    ];

    return createTableSQLs;
  }

  Future<void> insertAll(
      final List<Encryptable> encryptables, final DatabaseTables table) async {
    throw UnimplementedError();
  }

  Future<void> insert(
      final Encryptable encryptable, final DatabaseTables table) async {
    final EncryptionWrapper wrapper =
        Encryptor.encrypt(_encryptionPassword, encryptable);

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

  Future<List<EncryptionWrapper>> readEncrypted(
      {final String where,
      final List whereArgs,
      String orderBy,
      final DatabaseTables table}) async {
    return (await _database.query(table.name,
                where: where, whereArgs: whereArgs, orderBy: orderBy))
            .map((queryResult) => EncryptionWrapper.fromJson(queryResult))
            .toList() ??
        List.empty();
  }

  Future<bool> exists(final String id, final DatabaseTables table) async {
    return (await _database
            .query(table.name, where: 'id = ?', whereArgs: [id])) !=
        null;
  }

  Future<Map<String, dynamic>> read(
      final Encryptable encryptable, final DatabaseTables table) async {
    return (await _database
            .query(table.name, where: 'id = ?', whereArgs: [encryptable.id]))
        .map((queryResult) => EncryptionWrapper.fromJson(queryResult))
        .map((wrapper) => Decryptor.decrypt(_encryptionPassword, wrapper))
        .first;
  }

  Future<List<Map<String, dynamic>>> readAll(final DatabaseTables table) async {
    return (await _database.query(table.name))
        .map((queryResult) => EncryptionWrapper.fromJson(queryResult))
        .map((wrapper) => Decryptor.decrypt(_encryptionPassword, wrapper))
        .toList();
  }
}

enum DatabaseTables { bouncers, secrets }

extension DatabaseTableNames on DatabaseTables {
  get name {
    switch (this) {
      case DatabaseTables.secrets:
        return 'secrets';
      case DatabaseTables.bouncers:
        return 'bouncers';
    }
  }
}
