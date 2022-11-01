import '../models/config_app_model.dart';
import '../datasources/config_app_datasource.dart';
import '../../domain/repositories/iconfig_app_repository.dart';

class ConfigAppRepositoryImpl implements IConfigAppRepository<ConfigAppModel> {
  final IConfigAppDataSource<ConfigAppModel> dataSource;

  ConfigAppRepositoryImpl({required this.dataSource});

  @override
  Future<Map<String?, int?>> getAllConfigsByModulo({required String modulo}) async {
    return await dataSource.getAllConfigsByModulo(modulo: modulo);
  }

  @override
  Future<ConfigAppModel?> getConfig({required String identificador}) async {
    return await dataSource.getConfig(identificador: identificador);
  }

  @override
  Future<int?> updateConfig({required ConfigAppModel config}) async {
    return await dataSource.updateConfig(config: config);
  }
}