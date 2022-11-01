import '../repositories/iconfig_app_repository.dart';
import '../../data/models/config_app_model.dart';

class ConfigAppUseCase {
  final IConfigAppRepository<ConfigAppModel> repository;

  ConfigAppUseCase({required this.repository});

  Future<int?> updateConfig({required ConfigAppModel config}) {
    return repository.updateConfig(config: config);
  }

  Future<ConfigAppModel?> getConfig({required String identificador}) {
    return repository.getConfig(identificador: identificador);
  }

  Future<Map<String?, int?>> getAllConfigs({required String modulo}) {
    return repository.getAllConfigsByModulo(modulo: modulo);
  }
}