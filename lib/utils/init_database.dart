import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> initDatabase() async {
  return await openDatabase(
    join(await getDatabasesPath(), "note.db"),
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        """
          CREATE TABLE IF NOT EXISTS NOTE(
            id INTEGER PRIMARY KEY,
            titulo TEXT NOT NULL,
            data DATETIME NOT NULL,
            situacao INTEGER NOT NULL,
            imagem_fundo TEXT,
            observacao TEXT
          )
        """
      );
    }
  );
}