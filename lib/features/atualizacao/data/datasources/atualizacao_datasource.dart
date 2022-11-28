import 'package:sqflite/sqflite.dart';

import '../../../../core/databases/init_database.dart';
import '../models/atualizacao_model.dart';

abstract class AtualizacaoDataSource {
  Future<List<AtualizacaoModel>> findAllByVersaoWithoutVisualizacao(int versao);
  Future<int> insertVisualizacao(int versao);
  Future<int> getLastVersion();
   Future<List<AtualizacaoModel>> findAllByVersao(int versao);
}

class AtualizacaoDataSourceImpl implements AtualizacaoDataSource {
  late Database _db;

  Future<void> getConnection() async {
    _db = await getDatabase();
  }

  Future<void> closeConnection() async {
    await _db.close();
  }

  @override
  Future<List<AtualizacaoModel>> findAllByVersao(int versao) async {
    await getConnection();

    String sql = """
      SELECT
        ID,
        ID_VERSAO,
        CABECALHO,
        DESCRICAO,
        IMAGEM
      FROM ATUALIZACAO
      WHERE ID_VERSAO = ?
    """;

    List<Map<String, Object?>> result = await _db.rawQuery(sql, [ versao ]);
    List<AtualizacaoModel> response = [];

    result.forEach((item) {
      response.add(AtualizacaoModel.fromJson(item));
    });

    await closeConnection();

    return response;
  }

  @override
  Future<List<AtualizacaoModel>> findAllByVersaoWithoutVisualizacao(int versao) async {
    await getConnection();

    String sql = """
      SELECT
        ID,
        ID_VERSAO,
        CABECALHO,
        DESCRICAO,
        IMAGEM
      FROM ATUALIZACAO
      WHERE ID_VERSAO = ? AND ID_VERSAO NOT IN (
        SELECT ID_VERSAO FROM VISUALIZACAO
      )
    """;

    List<Map<String, Object?>> result = await _db.rawQuery(sql, [ versao ]);
    List<AtualizacaoModel> response = [];

    result.forEach((item) {
      response.add(AtualizacaoModel.fromJson(item));
    });

    await closeConnection();

    return response;
  }

  @override
  Future<int> insertVisualizacao(int versao) async {
    await getConnection();

    String sql = """
      INSERT INTO VISUALIZACAO (ID_USUARIO, ID_VERSAO)
      VALUES (1, ?)
    """;

    int insert = await _db.rawInsert(sql, [ versao ]);

    await closeConnection();

    return insert;
  }

  @override
  Future<int> getLastVersion() async {
    await getConnection();

    String sql = """
      SELECT ID FROM VERSAO ORDER BY VERSAO DESC LIMIT 1
    """;

    List<Map<String, Object?>> result = await _db.rawQuery(sql);

    return result[0]["id"] as int;
  }
}