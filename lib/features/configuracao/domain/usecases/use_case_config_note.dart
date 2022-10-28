import '../repositories/iconfig_note_repository.dart';
import '../../data/models/config_note_model.dart';

class UseCaseConfigNote {
  final IConfigNoteRepository<ConfigNoteModel> repository;

  UseCaseConfigNote({required this.repository});

  Future<int?> updateConfig({required ConfigNoteModel config}) {
    return repository.updateConfig(config: config);
  }

  Future<ConfigNoteModel?> getConfig({required String identificador}) {
    return repository.getConfig(identificador: identificador);
  }

  Future<Map<String?, int?>> getAllConfigs({required String modulo}) {
    return repository.getAllConfigsByModulo(modulo: modulo);
  }
}