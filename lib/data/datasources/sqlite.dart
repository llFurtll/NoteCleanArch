import 'package:note/data/datasources/datasource.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../domain/entities/anotacao.dart';

class SqliteDatasource implements DatasourceBase<dynamic> {

  SqliteDatasource();

  @override
  Future<List<Anotacao>> findAll() async {
    Database db = await getConnection();
    List<Anotacao> listAnotacao = [];
    
    List<Map> listNote = await db.rawQuery("SELECT * FROM NOTE");

    listNote.forEach((elemento) {
      listAnotacao.add(Anotacao.fromJson(elemento));
    });

    return listAnotacao;
  }

  @override
  Future<Anotacao> getById({required int id}) async {
    Database db = await getConnection();

    List<Map> note = await db.rawQuery(
      """
      SELECT * FROM NOTE WHERE ID = ?
      """,
      [id]
    );

    await db.close();

    Anotacao anotacao = Anotacao.fromJson(note[0]);

    return anotacao;
  }

  @override
  Future<int?> insert({required Anotacao anotacao}) async {
    Database db = await getConnection();
    int? inserted;

    db.transaction((txn) async {
      inserted = await txn.rawInsert(
        """INSERT INTO NOTE(titulo, data, situacao, imagem_fundo, observacao)
           VALUES(?, ?, ?, ?, ?)
        """,
        [anotacao.titulo, anotacao.data, anotacao.imagemFundo, anotacao.observacao]
      );
    });

    await db.close();

    return inserted;
  }

  @override
  Future<int?> delete({required int id}) async {
    Database db = await getConnection();
    int? deleted;

    deleted = await db.rawDelete(
      "DELETE FROM NOTE WHERE ID = ?", [id]
    );

    await db.close();

    return deleted;
  }

  @override
  Future<int?> update({required Anotacao anotacao}) async {
    Database db = await getConnection();
    int? updated;

    updated = await db.rawUpdate(
      """
      UPDATE NOTE SET TITULO = ?, DATA = ?, SITUACAO = ?, IMAGEM_FUNDO = ?, OBSERVACAO = ? WHERE ID = ?
      """,
      [
        anotacao.titulo, anotacao.data, anotacao.situacao,
        anotacao.imagemFundo, anotacao.observacao, anotacao.id
      ]
    );

    await db.close();

    return updated;
  }

  @override
  Future<Database> getConnection() async {
    return await openDatabase(
      join(await getDatabasesPath(), "note.db"),
      version: 1,
      onCreate: (db, version) => db.execute("""
          CREATE TABLE NOTE(
            id INTEGER PRIMARY KEY,
            titulo TEXT NOT NULL,
            data DATETIME NOT NULL,
            situacao BOOLEAN NOT NULL,
            imagem_fundo TEXT,
            observacao TEXT
          )
        """
      )
    );
  }
}