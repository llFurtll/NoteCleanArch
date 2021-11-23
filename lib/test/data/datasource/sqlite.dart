import 'package:note/data/datasources/datasource.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/test/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class DatasourceTest implements DatasourceBase<AnotacaoModel> {
  
  late Database _db;

  Future<void> getConnection() async {
  
    _db = await inicializeDatabase();
  }

  Future<void> closeConnection() async {
    await _db.close();
  }

  @override
  Future<List<AnotacaoModel?>> findAll() async {
    await getConnection();

    List<AnotacaoModel?> listAnotacao = [];
    
    List<Map>? listNote = await _db.rawQuery("SELECT * FROM NOTE WHERE SITUACAO = 1 ORDER BY DATA DESC");

    listNote.forEach((elemento) {
      listAnotacao.add(AnotacaoModel.fromJson(elemento));
    });

    await closeConnection();

    return listAnotacao;
  }

  @override
  Future<AnotacaoModel> getById({required int id}) async {
    await getConnection();
    
    List<Map> note = await _db.rawQuery(
      """
      SELECT * FROM NOTE WHERE ID = ?
      """,
      [id]
    );

    AnotacaoModel anotacao = AnotacaoModel.fromJson(note[0]);

    await closeConnection();

    return anotacao;
  }

  @override
  Future<int?> insert({required AnotacaoModel anotacao}) async {
    await getConnection();

    int? insert;

    insert = await _db.rawInsert(
      """INSERT INTO NOTE(titulo, data, situacao, imagem_fundo, observacao, cor)
          VALUES(?, ?, ?, ?, ?, ?)
      """,
      [anotacao.titulo, anotacao.data, anotacao.situacao, anotacao.imagemFundo, anotacao.observacao, anotacao.cor]
    );

    await closeConnection();

    return insert;
  }

  @override
  Future<int?> delete({required int id}) async {
    await getConnection();

    int? delete;

    delete = await _db.rawDelete(
      "DELETE FROM NOTE WHERE ID = ?", [id]
    );

    await closeConnection();

    return delete;
  }

  @override
  Future<int?> update({required AnotacaoModel anotacao}) async {
    await getConnection();

    int update;

    update = await _db.rawUpdate(
      """
      UPDATE NOTE SET TITULO = ?, DATA = ?, SITUACAO = ?, IMAGEM_FUNDO = ?, OBSERVACAO = ?, COR = ? WHERE ID = ?
      """,
      [
        anotacao.titulo, anotacao.data, anotacao.situacao,
        anotacao.imagemFundo, anotacao.observacao, anotacao.cor, anotacao.id
      ]
    );

    await closeConnection();

    return update;
  }

  @override
  Future<int?> updateSituacao({required AnotacaoModel anotacao}) async {
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

  Future<List<AnotacaoModel?>> findWithDesc({String desc = ""}) async {
    await getConnection();

    List<AnotacaoModel> listAnotacao = [];
    
    List<Map> listNote = await _db.rawQuery(
      "SELECT * FROM NOTE WHERE SITUACAO = 1 AND TITULO LIKE '%$desc%' ORDER BY DATA DESC"
    );

    listNote.forEach((elemento) {
      listAnotacao.add(AnotacaoModel.fromJson(elemento));
    });

    await closeConnection();

    return listAnotacao;
  }
  
}