import '../entities/config_note.dart';

abstract class IConfigNoteRepository<T extends ConfigNote> {
  Future<int?> updateConfig({required T config});
  Future<T?> getConfig({required String identificador});
  Future<Map<String?, int?>> getAllConfigsByModulo({required String modulo});
}