import 'package:compmanager/core/compmanager_injector.dart';
import 'package:note/data/datasources/sqlite.dart';
import 'package:note/data/repositories/config_repository.dart';
import 'package:note/data/repositories/crud_repository.dart';
import 'package:note/domain/usecases/config_user_usecases.dart';
import 'package:note/domain/usecases/crud_usecases.dart';

void registerDependencies() {
  CompManagerInjector injector = CompManagerInjector();

  injector.registerDependencie(SqliteDatasource());
  injector.registerDependencie(CrudRepository(datasourceBase: injector.getDependencie()));
  injector.registerDependencie(CrudUseCases(repository: injector.getDependencie()));
  injector.registerDependencie(ConfigUserRepository(datasourceBase: injector.getDependencie()));
  injector.registerDependencie(ConfigUserUseCases(configRepository: injector.getDependencie()));
}