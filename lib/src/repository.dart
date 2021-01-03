import 'package:lokr_ui/src/storage_provider.dart';

abstract class Repository<T> {
  final EncryptionStorageProvider storageProvider = EncryptionStorageProvider();

  Future<List<T>> findAll();

  Future<T> find(T instance);

  Future<void> save(T instance);

  Future<void> saveAll(List<T> instances);

  Future<void> delete(T instance);
}
