import 'package:sqflite/sqflite.dart';

import '../../../../core/utils/init_database.dart';

abstract class ConfigUserDataSource {
  Future<String?> getImage();
  Future<String?> getName();
  Future<int?> updateImage({required String pathImage});
  Future<int?> updateName({required String name});
}

class ConfigUserDataSourceImpl implements ConfigUserDataSource {
  late Database _db;

  Future<void> getConnection() async {
    _db = await getDatabase();
  }

  Future<void> closeConnection() async {
    await _db.close();
  }

  @override
  Future<String?> getImage() async {
    await getConnection();

    List<Map> result = await _db.rawQuery(
      "SELECT PATH_FOTO FROM CONFIGUSER WHERE ID = 1"
    );


    await closeConnection();

    if (result.length > 0) {
      return result.first['path_foto'];
    } else {
      return null;
    }
  }

  @override
  Future<String?> getName() async {
    await getConnection();

    List<Map> result = await _db.rawQuery(
      "SELECT NOME FROM CONFIGUSER WHERE ID = 1"
    );

    await closeConnection();

    if (result.length > 0) {
      return result.first['nome'];
    } else {
      return null;
    }
  }

  @override
  Future<int?> updateImage({required String pathImage}) async {
    await getConnection();

    int? updated = await _db.rawUpdate(
      "UPDATE CONFIGUSER SET PATH_FOTO = ? WHERE ID = 1", [pathImage]
    );

    await closeConnection();

    return updated;
  }

  @override
  Future<int?> updateName({required String name}) async {
    await getConnection();

    int? updated = await _db.rawUpdate(
      "UPDATE CONFIGUSER SET NOME = ? WHERE ID = 1", [ name ]
    );

    await closeConnection();

    return updated;
  }
}