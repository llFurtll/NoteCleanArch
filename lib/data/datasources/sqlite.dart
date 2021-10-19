import 'package:note/data/datasources/datasource.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatasource implements DatasourceBase<AnotacaoModel> {

  Database db;

  SqliteDatasource({required this.db});

  @override
  Future<List<AnotacaoModel>> findAll() async {
    List<AnotacaoModel> listAnotacao = [];
    
    List<Map> listNote = await db.rawQuery("SELECT * FROM NOTE WHERE SITUACAO = 1 ORDER BY DATA DESC");

    listNote.forEach((elemento) {
      listAnotacao.add(AnotacaoModel.fromJson(elemento));
    });

    return listAnotacao;
  }

  @override
  Future<AnotacaoModel> getById({required int id}) async {
    List<Map> note = await db.rawQuery(
      """
      SELECT * FROM NOTE WHERE ID = ?
      """,
      [id]
    );

    AnotacaoModel anotacao = AnotacaoModel.fromJson(note[0]);

    return anotacao;
  }

  @override
  Future<int?> insert({required AnotacaoModel anotacao}) async {
    int? insert;

    insert = await db.rawInsert(
      """INSERT INTO NOTE(titulo, data, situacao, imagem_fundo, observacao, cor)
          VALUES(?, ?, ?, ?, ?, ?)
      """,
      [anotacao.titulo, anotacao.data, anotacao.situacao, anotacao.imagemFundo, anotacao.observacao, anotacao.cor]
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
  Future<int?> update({required AnotacaoModel anotacao}) async {
    int update;

    update = await db.rawUpdate(
      """
      UPDATE NOTE SET TITULO = ?, DATA = ?, SITUACAO = ?, IMAGEM_FUNDO = ?, OBSERVACAO = ?, COR = ? WHERE ID = ?
      """,
      [
        anotacao.titulo, anotacao.data, anotacao.situacao,
        anotacao.imagemFundo, anotacao.observacao, anotacao.cor, anotacao.id
      ]
    );

    return update;
  }

  @override
  Future<int?> updateSituacao({required AnotacaoModel anotacao}) async {
    int update;

    update = await db.rawUpdate(
      """
      UPDATE NOTE SET SITUACAO = ? WHERE ID = ?
      """,
      [
        anotacao.situacao, anotacao.id
      ]
    );

    return update;
  }
}