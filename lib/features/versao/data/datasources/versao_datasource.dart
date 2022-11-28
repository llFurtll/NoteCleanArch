import 'package:sqflite/sqflite.dart';

import '../../../../core/databases/init_database.dart';
import '../models/versao_model.dart';

abstract class VersaoDataSource {
  Future<List<VersaoModel>> findAll();
}

class VersaoDataSourceImpl implements VersaoDataSource {
  late Database _db;

  Future<void> getConnection() async {
    _db = await getDatabase();
  }

  Future<void> closeConnection() async {
    await _db.close();
  }

  @override
  Future<List<VersaoModel>> findAll() async {
    await getConnection();

    String sql = """
      SELECT ID, VERSAO FROM VERSAO ORDER BY VERSAO
    """;

    final result = await _db.rawQuery(sql);
    final List<VersaoModel> response = [];

    result.forEach((item) => response.add(VersaoModel.fromJson(item)));

    await closeConnection();

    return response;
  }
}