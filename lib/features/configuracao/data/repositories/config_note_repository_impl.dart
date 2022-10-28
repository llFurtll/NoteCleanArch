import '../models/config_note_model.dart';
import '../datasources/config_note_datasource.dart';
import '../../domain/repositories/iconfig_note_repository.dart';

class ConfigNoteRepositoryImpl implements IConfigNoteRepository<ConfigNoteModel> {
  final IConfigNoteDataSource<ConfigNoteModel> dataSource;

  ConfigNoteRepositoryImpl({required this.dataSource});

  @override
  Future<Map<String?, int?>> getAllConfigsByModulo({required String modulo}) async {
    return await dataSource.getAllConfigsByModulo(modulo: modulo);
  }

  @override
  Future<ConfigNoteModel?> getConfig({required String identificador}) async {
    return await dataSource.getConfig(identificador: identificador);
  }

  @override
  Future<int?> updateConfig({required ConfigNoteModel config}) async {
    return await dataSource.updateConfig(config: config);
  }
}