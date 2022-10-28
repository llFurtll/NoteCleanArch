import 'package:sqflite/sqflite.dart';

import '../../../../core/utils/init_database.dart';
import '../models/config_note_model.dart';
import '../../domain/entities/config_note.dart';

abstract class IConfigNoteDataSource<T extends ConfigNote> {
  Future<int?> updateConfig({required T config});
  Future<T?> getConfig({required String identificador});
  Future<Map<String?, int?>> getAllConfigsByModulo({required String modulo});
}

class ConfigNoteDataSourceImpl implements IConfigNoteDataSource<ConfigNoteModel> {
  late Database _db;
  final bool test;

  ConfigNoteDataSourceImpl({
    required this.test
  });

  Future<void> getConnection() async {
    _db = await getDatabase(test);
  }

  Future<void> closeConnection() async {
    await _db.close();
  }

  @override
  Future<Map<String?, int?>> getAllConfigsByModulo({required String modulo}) async {
    await getConnection();

    Map<String?, int?> response = {};

    List<Map> result = await _db.rawQuery("SELECT * FROM CONFIGNOTE WHERE MODULO = ?", [ modulo ]);

    result.forEach((element) {
      ConfigNoteModel config = ConfigNoteModel.fromJson(element);
      response[config.identificador] = config.valor;
    });

    await closeConnection();

    return response;
  }

  @override
  Future<ConfigNoteModel?> getConfig({required String identificador}) async {
    await getConnection();

    List<Map> result = await _db.rawQuery("SELECT * FROM CONFIGNOTE WHERE IDENTIFICADOR = ?", [ identificador ]);

    ConfigNoteModel? config = ConfigNoteModel.fromJson(result[0]);

    await closeConnection();

    return config;
  }

  @override
  Future<int?> updateConfig({required ConfigNoteModel config}) async {
    await getConnection();

    int? update = await _db.rawUpdate("UPDATE CONFIGNOTE SET VALOR = ? WHERE IDENTIFICADOR = ?", [ config.valor, config.identificador ]);

    await closeConnection();

    return update;
  }
}