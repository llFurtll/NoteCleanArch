import '../../data/datasources/note_datasource.dart';
import '../../data/model/note_model.dart';
import '../../domain/repositories/inote_repository.dart';

class NoteRepositoryImpl implements INoteRepository<NoteModel> {

  NoteDataSource<NoteModel> datasourceBase;

  NoteRepositoryImpl({required this.datasourceBase});

  @override
  Future<int?> insert({required NoteModel anotacao}) async {
    return await datasourceBase.insert(anotacao: anotacao);
  }
  
  @override
  Future<int?> update({required NoteModel anotacao}) async {
    return await datasourceBase.update(anotacao: anotacao);
  }

  @override
  Future<NoteModel?> getById({required int id}) async {
    return await datasourceBase.getById(id: id);
  }

  @override
  Future<int?> updateSituacao({required NoteModel anotacao}) async {
    return await datasourceBase.updateSituacao(anotacao: anotacao);
  }

  @override
  Future<int?> removeBackgroundNote({required String image}) async {
    int? update = await datasourceBase.removeBackgroundNote(image: image);
    return update;
  }
}