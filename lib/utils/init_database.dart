import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> initDatabase() async {
  await openDatabase(
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
            observacao TEXT,
            cor TEXT
          )
        """
      );

      await db.execute(
        """
          CREATE TABLE IF NOT EXISTS CONFIGUSER(
            id INTEGER PRIMARY KEY,
            path_foto TEXT DEFAULT NULL
            nome TEXT DEFAULT NULL
          )
        """
      );
    }
  );
}