import 'package:sqflite/sqflite.dart';

import '../../../../core/databases/init_database.dart';
import '../models/atualizacao_model.dart';

abstract class AtualizacaoDataSource {
  Future<List<AtualizacaoModel>> findAllByVersao(double versao);
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
}