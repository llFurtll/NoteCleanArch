import 'package:compmanager/core/compmanager_injector.dart';

import 'features/config_user/data/datasources/config_user_datasource.dart';
import 'features/config_user/data/repositories/config_user_repository_impl.dart';
import 'features/config_user/domain/usecases/config_user_use_case.dart';

import 'features/note/data/datasources/sqlite.dart';
import 'features/note/data/repositories/crud_repository.dart';
import 'features/note/domain/usecases/crud_usecases.dart';

import 'features/configuracao/data/datasources/config_note_datasource.dart';
import 'features/configuracao/data/repositories/config_note_repository_impl.dart';
import 'features/configuracao/domain/usecases/use_case_config_note.dart';

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
  injector.registerDependencie(ConfigNoteDataSourceImpl(test: false));
  injector.registerDependencie(ConfigNoteRepositoryImpl(dataSource: injector.getDependencie()));
  injector.registerDependencie(UseCaseConfigNote(repository: injector.getDependencie()));
}