import 'package:sqflite/sqflite.dart';

import '../../../../core/databases/init_database.dart';
import '../models/atualizacao_model.dart';

abstract class AtualizacaoDataSource {
  Future<List<AtualizacaoModel>> findAllByVersao(double versao);
  Future<int> insertVisualizacao(double versao);
  Future<double> getLastVersion();
  Future<List<double>> getAllVersions();
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
  Future<List<AtualizacaoModel>> findAllByVersao(double versao) async {
    await getConnection();

    String sql = """
      SELECT
        ID,
        VERSAO,
        CABECALHO,
        DESCRICAO,
        IMAGEM
      FROM ATUALIZACAO
      WHERE VERSAO = ? AND VERSAO NOT IN (
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
  Future<int> insertVisualizacao(double versao) async {
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
  Future<double> getLastVersion() async {
    await getConnection();

    String sql = """
      SELECT MAX(VERSAO) AS VERSAO FROM ATUALIZACAO
      GROUP BY VERSAO;
    """;

    List<Map<String, Object?>> result = await _db.rawQuery(sql);

    return result[0]["VERSAO"] as double;
  }

  @override
  Future<List<double>> getAllVersions() async {
    await getConnection();

    String sql = """
      SELECT VERSAO FROM ATUALIZACAO
      GROUP BY VERSAO;
    """;

    List<Map<String, Object?>> result = await _db.rawQuery(sql);
    List<double> response = [];

    result.forEach((item) {
      response.add(item["VERSAO"] as double);
    });
    
    await closeConnection();

    return response;
  }
}