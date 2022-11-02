import '../../data/datasources/note_datasource.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/inote_repository.dart';

class NoteRepositoryImpl implements INoteRepository {

  NoteDataSource datasourceBase;

  NoteRepositoryImpl({required this.datasourceBase});

  @override
  Future<int?> insert({required Note note}) async {
    return await datasourceBase.insert(note: note);
  }
  
  @override
  Future<int?> update({required Note note}) async {
    return await datasourceBase.update(note: note);
  }

  @override
  Future<Note> getById({required int id}) async {
    return await datasourceBase.getById(id: id);
  }

  @override
  Future<int?> updateSituacao({required Note note}) async {
    return await datasourceBase.updateSituacao(note: note);
  }

  @override
  Future<int?> removeBackgroundNote({required String image}) async {
    int? update = await datasourceBase.removeBackgroundNote(image: image);
    return update;
  }
}