import 'package:sqflite/sqflite.dart';

import '../../../../core/utils/init_database.dart';
import '../../domain/entities/note.dart';
import '../../data/model/note_model.dart';

abstract class NoteDataSource<T extends Note> {
  Future<T?> getById({required int id});
  Future<int?> insert({required T anotacao});
  Future<int?> update({required T anotacao});
  Future<int?> updateSituacao({required T anotacao});
  Future<int?> removeBackgroundNote({required String image});
}

class NoteDataSourceImpl implements NoteDataSource<NoteModel> {
  
  late Database _db;
  final bool test;

  NoteDataSourceImpl({
    required this.test
  });

  Future<void> getConnection() async {
    _db = await getDatabase(test);
  }

  Future<void> closeConnection() async {
    await _db.close();
  }

  @override
  Future<NoteModel> getById({required int id}) async {
    await getConnection();
    
    List<Map> note = await _db.rawQuery(
      """
      SELECT * FROM NOTE WHERE ID = ?
      """,
      [id]
    );

    NoteModel anotacao = NoteModel.fromJson(note[0]);

    await closeConnection();

    return anotacao;
  }

  @override
  Future<int?> insert({required NoteModel anotacao}) async {
    await getConnection();

    int? insert;

    insert = await _db.rawInsert(
      """INSERT INTO NOTE(titulo, data, situacao, imagem_fundo, observacao)
          VALUES(?, ?, ?, ?, ?)
      """,
      [anotacao.titulo, anotacao.data, anotacao.situacao, anotacao.imagemFundo, anotacao.observacao]
    );

    await closeConnection();

    return insert;
  }

  @override
  Future<int?> update({required NoteModel anotacao}) async {
    await getConnection();

    int update;

    update = await _db.rawUpdate(
      """
      UPDATE NOTE SET TITULO = ?, DATA = ?, SITUACAO = ?, IMAGEM_FUNDO = ?, OBSERVACAO = ? WHERE ID = ?
      """,
      [
        anotacao.titulo, anotacao.data, anotacao.situacao,
        anotacao.imagemFundo, anotacao.observacao, anotacao.id
      ]
    );

    await closeConnection();

    return update;
  }

  @override
  Future<int?> updateSituacao({required NoteModel anotacao}) async {
    await getConnection();

    int update;

    update = await _db.rawUpdate(
      """
      UPDATE NOTE SET SITUACAO = ? WHERE ID = ?
      """,
      [
        anotacao.situacao, anotacao.id
      ]
    );

    await closeConnection();

    return update;
  }

  @override
  Future<int?> removeBackgroundNote({required String image}) async {
    await getConnection();

    int? update = await _db.rawUpdate(
      """
      UPDATE NOTE SET imagem_fundo = '' WHERE imagem_fundo = ?
      """,
      [ image ]
    );

    await closeConnection();

    return update;
  }
}