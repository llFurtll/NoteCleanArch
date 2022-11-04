import '../entities/config_app.dart';

abstract class IConfigAppRepository {
  Future<int?> updateConfig({required ConfigApp config});
  Future<ConfigApp?> getConfig({required String identificador});
  Future<Map<String?, int?>> getAllConfigsByModulo({required String modulo});
}