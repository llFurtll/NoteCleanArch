import '../../data/model/note_model.dart';
import '../repositories/inote_repository.dart';

class NoteUseCase {
  INoteRepository<NoteModel> repository;

  NoteUseCase({required this.repository});

  Future<int?> insertUseCase({required NoteModel anotacao}) async {
    return await repository.insert(anotacao: anotacao);
  }

  Future<int?> updateUseCase({required NoteModel anotacao}) async {
    return await repository.update(anotacao: anotacao);
  }

  Future<NoteModel?> getByIdUseCase({required int id}) async {
    return await repository.getById(id: id);
  }

  Future<int?> updateSituacaoUseCase({required NoteModel anotacao}) async {
    anotacao.situacao = anotacao.situacao == 1 ? 0 : 1;
    return await repository.updateSituacao(anotacao: anotacao);
  }

  Future<int?> removeBackgroundNote({required String image}) async {
    int? update = await repository.removeBackgroundNote(image: image);
    return update;
  }
}