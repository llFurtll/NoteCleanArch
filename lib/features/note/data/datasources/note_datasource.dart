import 'package:sqflite/sqflite.dart';

import '../../../../core/utils/init_database.dart';
import '../../data/model/note_model.dart';
import '../../domain/entities/note.dart';

abstract class NoteDataSource {
  Future<NoteModel> getById({required int id});
  Future<int?> insert({required Note note});
  Future<int?> update({required Note note});
  Future<int?> updateSituacao({required Note note});
  Future<int?> removeBackgroundNote({required String image});
}

class NoteDataSourceImpl implements NoteDataSource {
  
  late Database _db;

  Future<void> getConnection() async {
    _db = await getDatabase();
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
  Future<int?> insert({required Note note}) async {
    await getConnection();

    int? insert;

    insert = await _db.rawInsert(
      """INSERT INTO NOTE(titulo, data, situacao, imagem_fundo, observacao)
          VALUES(?, ?, ?, ?, ?)
      """,
      [note.titulo, note.data, note.situacao, note.imagemFundo, note.observacao]
    );

    await closeConnection();

    return insert;
  }

  @override
  Future<int?> update({required Note note}) async {
    await getConnection();

    int update;

    update = await _db.rawUpdate(
      """
      UPDATE NOTE SET TITULO = ?, DATA = ?, SITUACAO = ?, IMAGEM_FUNDO = ?, OBSERVACAO = ? WHERE ID = ?
      """,
      [
        note.titulo, note.data, note.situacao,
        note.imagemFundo, note.observacao, note.id
      ]
    );

    await closeConnection();

    return update;
  }

  @override
  Future<int?> updateSituacao({required Note note}) async {
    await getConnection();

    int update;

    update = await _db.rawUpdate(
      """
      UPDATE NOTE SET SITUACAO = ? WHERE ID = ?
      """,
      [
        note.situacao, note.id
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