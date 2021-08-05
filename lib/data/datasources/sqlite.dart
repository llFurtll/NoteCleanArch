import 'package:note/data/datasources/datasource.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/anotacao.dart';

class SqliteDatasource implements DatasourceBase<dynamic> {

  Database db;

  SqliteDatasource({required this.db});

  @override
  Future<List<Anotacao>> findAll() async {
    List<Anotacao> listAnotacao = [];
    
    List<Map> listNote = await db.rawQuery("SELECT * FROM NOTE");

    listNote.forEach((elemento) {
      listAnotacao.add(Anotacao.fromJson(elemento));
    });

    return listAnotacao;
  }

  @override
  Future<Anotacao> getById({required int id}) async {
    List<Map> note = await db.rawQuery(
      """
      SELECT * FROM NOTE WHERE ID = ?
      """,
      [id]
    );

    Anotacao anotacao = Anotacao.fromJson(note[0]);

    return anotacao;
  }

  @override
  Future<int?> insert({required Anotacao anotacao}) async {
    int? insert;

    insert = await db.rawInsert(
      """INSERT INTO NOTE(titulo, data, situacao, imagem_fundo, observacao)
          VALUES(?, ?, ?, ?, ?)
      """,
      [anotacao.titulo, anotacao.data, anotacao.situacao, anotacao.imagemFundo, anotacao.observacao]
    );

    return insert;
  }

  @override
  Future<int?> delete({required int id}) async {
    int? delete;

    delete = await db.rawDelete(
      "DELETE FROM NOTE WHERE ID = ?", [id]
    );

    return delete;
  }

  @override
  Future<int?> update({required Anotacao anotacao}) async {
    int update;

    update = await db.rawUpdate(
      """
      UPDATE NOTE SET TITULO = ?, DATA = ?, SITUACAO = ?, IMAGEM_FUNDO = ?, OBSERVACAO = ? WHERE ID = ?
      """,
      [
        anotacao.titulo, anotacao.data, anotacao.situacao,
        anotacao.imagemFundo, anotacao.observacao, anotacao.id
      ]
    );

    return update;
  }
}