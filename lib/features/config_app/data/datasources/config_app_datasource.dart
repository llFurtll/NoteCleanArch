import 'package:sqflite/sqflite.dart';

import '../../../../core/utils/init_database.dart';
import '../models/config_app_model.dart';
import '../../domain/entities/config_app.dart';

abstract class IConfigAppDataSource {
  Future<int?> updateConfig({required ConfigApp config});
  Future<ConfigAppModel?> getConfig({required String identificador});
  Future<Map<String?, int?>> getAllConfigsByModulo({required String modulo});
}

class ConfigAppDataSourceImpl implements IConfigAppDataSource {
  late Database _db;

  Future<void> getConnection() async {
    _db = await getDatabase();
  }

  Future<void> closeConnection() async {
    await _db.close();
  }

  @override
  Future<Map<String?, int?>> getAllConfigsByModulo({required String modulo}) async {
    await getConnection();

    Map<String?, int?> response = {};

    List<Map> result = await _db.rawQuery("SELECT * FROM CONFIGAPP WHERE MODULO = ?", [ modulo ]);

    result.forEach((element) {
      ConfigAppModel config = ConfigAppModel.fromJson(element);
      response[config.identificador] = config.valor;
    });

    await closeConnection();

    return response;
  }

  @override
  Future<ConfigAppModel?> getConfig({required String identificador}) async {
    await getConnection();

    List<Map> result = await _db.rawQuery("SELECT * FROM CONFIGAPP WHERE IDENTIFICADOR = ?", [ identificador ]);

    ConfigAppModel? config = ConfigAppModel.fromJson(result[0]);

    await closeConnection();

    return config;
  }

  @override
  Future<int?> updateConfig({required ConfigApp config}) async {
    await getConnection();

    int? update = await _db.rawUpdate("UPDATE CONFIGAPP SET VALOR = ? WHERE IDENTIFICADOR = ?", [ config.valor, config.identificador ]);

    await closeConnection();

    return update;
  }
}