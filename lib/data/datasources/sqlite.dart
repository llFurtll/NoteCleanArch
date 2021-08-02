import 'package:note/data/datasources/datasource.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../domain/entities/anotacao.dart';

class SqliteDatasource implements DatasourceBase<Database> {

  SqliteDatasource();

  @override
  Future<List<Anotacao>> findAll() async {
    return Future.value(null);
  }

  @override
  Future<Anotacao> getById({required int id}) async {
    return Future.value(null);
  }

  @override
  Future<Database> create({required Anotacao anotacaoModel}) async {
    return Future.value(null);
  }

  @override
  Future<Database> delete({required int id}) async {
    return Future.value(null);
  }

  @override
  Future<Database> update({required int id}) async {
    return Future.value(null);
  }

  @override
  Future<Database> getConnection() async {
    return await openDatabase(
      join(await getDatabasesPath(), "note.db"),
      version: 1,
      onCreate: (db, version) => db.execute("""
          CREATE TABLE TEST(
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        """
      )
    );
  }
}