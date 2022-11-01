import '../entities/config_app.dart';

abstract class IConfigAppRepository<T extends ConfigApp> {
  Future<int?> updateConfig({required T config});
  Future<T?> getConfig({required String identificador});
  Future<Map<String?, int?>> getAllConfigsByModulo({required String modulo});
}