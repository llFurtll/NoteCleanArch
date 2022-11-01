import 'package:compmanager/core/compmanager_injector.dart';

import 'features/config_user/data/datasources/config_user_datasource.dart';
import 'features/config_user/data/repositories/config_user_repository_impl.dart';
import 'features/config_user/domain/usecases/config_user_use_case.dart';

import 'features/note/data/datasources/sqlite.dart';
import 'features/note/data/repositories/crud_repository.dart';
import 'features/note/domain/usecases/crud_usecases.dart';

import 'features/config_app/data/datasources/config_app_datasource.dart';
import 'features/config_app/data/repositories/config_app_repository_impl.dart';
import 'features/config_app/domain/usecases/config_app_use_case.dart';

void registerDependencies() {
  CompManagerInjector injector = CompManagerInjector();

  // Módulo do Note (Configuração do usuário)
  injector.registerDependencie(ConfigUserDataSourceImpl(test: false));
  injector.registerDependencie(ConfigUserRepositoryImpl(dataSource: injector.getDependencie()));
  injector.registerDependencie(ConfigUserUseCase(repository: injector.getDependencie()));

  // Módulo do Note (Crição)
  injector.registerDependencie(SqliteDatasource(test: false));
  injector.registerDependencie(CrudRepository(datasourceBase: injector.getDependencie()));
  injector.registerDependencie(CrudUseCases(repository: injector.getDependencie()));

  // Módulo de configuração do note
  injector.registerDependencie(ConfigAppDataSourceImpl(test: false));
  injector.registerDependencie(ConfigAppRepositoryImpl(dataSource: injector.getDependencie()));
  injector.registerDependencie(ConfigAppUseCase(repository: injector.getDependencie()));
}