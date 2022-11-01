import 'package:compmanager/core/compmanager_injector.dart';

import 'features/home/data/datasources/home_datasource.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/usecases/home_use_case.dart';

import 'features/config_user/data/datasources/config_user_datasource.dart';
import 'features/config_user/data/repositories/config_user_repository_impl.dart';
import 'features/config_user/domain/usecases/config_user_use_case.dart';

import 'features/note/data/datasources/note_datasource.dart';
import 'features/note/data/repositories/note_repository_impl.dart';
import 'features/note/domain/usecases/note_usecase.dart';

import 'features/config_app/data/datasources/config_app_datasource.dart';
import 'features/config_app/data/repositories/config_app_repository_impl.dart';
import 'features/config_app/domain/usecases/config_app_use_case.dart';

void registerDependencies() {
  CompManagerInjector injector = CompManagerInjector();

  // Página inicial
  injector.registerDependencie(HomeDataSourceImpl(test: false));
  injector.registerDependencie(HomeRepositoryImpl(dataSource: injector.getDependencie()));
  injector.registerDependencie(HomeUseCase(repository: injector.getDependencie()));

  // Configuração do usuário
  injector.registerDependencie(ConfigUserDataSourceImpl(test: false));
  injector.registerDependencie(ConfigUserRepositoryImpl(dataSource: injector.getDependencie()));
  injector.registerDependencie(ConfigUserUseCase(repository: injector.getDependencie()));

  // Criação da anotação
  injector.registerDependencie(NoteDataSourceImpl(test: false));
  injector.registerDependencie(NoteRepositoryImpl(datasourceBase: injector.getDependencie()));
  injector.registerDependencie(NoteUseCase(repository: injector.getDependencie()));

  // Configuração da aplicação
  injector.registerDependencie(ConfigAppDataSourceImpl(test: false));
  injector.registerDependencie(ConfigAppRepositoryImpl(dataSource: injector.getDependencie()));
  injector.registerDependencie(ConfigAppUseCase(repository: injector.getDependencie()));
}