import 'package:compmanager/core/compmanager_injector.dart';

import 'features/note/data/datasources/sqlite.dart';
import 'features/note/data/repositories/config_repository.dart';
import 'features/note/data/repositories/crud_repository.dart';
import 'features/note/domain/usecases/config_user_usecases.dart';
import 'features/note/domain/usecases/crud_usecases.dart';

import 'features/configuracao/data/datasources/config_note_datasource.dart';
import 'features/configuracao/data/repositories/config_note_repository_impl.dart';
import 'features/configuracao/domain/usecases/use_case_config_note.dart';

void registerDependencies() {
  CompManagerInjector injector = CompManagerInjector();

  // Módulo do Note (Listagem e criação)
  injector.registerDependencie(SqliteDatasource(test: false));
  injector.registerDependencie(CrudRepository(datasourceBase: injector.getDependencie()));
  injector.registerDependencie(CrudUseCases(repository: injector.getDependencie()));
  injector.registerDependencie(ConfigUserRepository(datasourceBase: injector.getDependencie()));
  injector.registerDependencie(ConfigUserUseCases(configRepository: injector.getDependencie()));

  // Módulo de configuração do note
  injector.registerDependencie(ConfigNoteDataSourceImpl(test: false));
  injector.registerDependencie(ConfigNoteRepositoryImpl(dataSource: injector.getDependencie()));
  injector.registerDependencie(UseCaseConfigNote(repository: injector.getDependencie()));
}