import 'package:note/data/datasources/sqlite.dart';
import 'package:note/data/repositories/crud_repository.dart';
import 'package:note/domain/usecases/usecases.dart';
import 'package:note/utils/init_database.dart';
import 'package:sqflite/sqflite.dart';

class GetConnectionDataSource {
  static late Database _db;
  static late SqliteDatasource _sqliteDatasource;
  static late CrudRepository _crudRepository;
  static late UseCases _useCases;

  static Future<UseCases> getConnection() async {
      _db = await initDatabase();
      _sqliteDatasource = SqliteDatasource(db: _db);
      _crudRepository = CrudRepository(datasourceBase: _sqliteDatasource);
      _useCases = UseCases(repository: _crudRepository);

      return _useCases;
  }

  static void closeConnection() async {
    await _db.close();
  }
}