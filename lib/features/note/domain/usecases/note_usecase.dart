import '../entities/note.dart';
import '../repositories/inote_repository.dart';

class NoteUseCase {
  INoteRepository repository;

  NoteUseCase({required this.repository});

  Future<int?> insertUseCase({required Note note}) async {
    return await repository.insert(note: note);
  }

  Future<int?> updateUseCase({required Note note}) async {
    return await repository.update(note: note);
  }

  Future<Note> getByIdUseCase({required int id}) async {
    return await repository.getById(id: id);
  }

  Future<int?> updateSituacaoUseCase({required Note note}) async {
    note.situacao = note.situacao == 1 ? 0 : 1;
    return await repository.updateSituacao(note: note);
  }

  Future<int?> removeBackgroundNote({required String image}) async {
    int? update = await repository.removeBackgroundNote(image: image);
    return update;
  }
}