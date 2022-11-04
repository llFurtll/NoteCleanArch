import '../datasources/config_app_datasource.dart';
import '../models/config_app_model.dart';
import '../../domain/repositories/iconfig_app_repository.dart';
import '../../domain/entities/config_app.dart';

class ConfigAppRepositoryImpl implements IConfigAppRepository {
  final IConfigAppDataSource dataSource;

  ConfigAppRepositoryImpl({required this.dataSource});

  @override
  Future<Map<String?, int?>> getAllConfigsByModulo({required String modulo}) async {
    return await dataSource.getAllConfigsByModulo(modulo: modulo);
  }

  @override
  Future<ConfigApp?> getConfig({required String identificador}) async {
    ConfigAppModel? configAppModel = await dataSource.getConfig(identificador: identificador);
    return ConfigAppModel.fromModel(configAppModel!);
  }

  @override
  Future<int?> updateConfig({required ConfigApp config}) async {
    return await dataSource.updateConfig(config: config);
  }
}