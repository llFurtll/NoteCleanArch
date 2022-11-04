import '../repositories/iconfig_app_repository.dart';
import '../entities/config_app.dart';

class ConfigAppUseCase {
  final IConfigAppRepository repository;

  ConfigAppUseCase({required this.repository});

  Future<int?> updateConfig({required ConfigApp config}) {
    return repository.updateConfig(config: config);
  }

  Future<ConfigApp?> getConfig({required String identificador}) {
    return repository.getConfig(identificador: identificador);
  }

  Future<Map<String?, int?>> getAllConfigs({required String modulo}) {
    return repository.getAllConfigsByModulo(modulo: modulo);
  }
}