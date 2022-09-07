import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

Future<void> initDatabase() async {
  await openDatabase(
    join(await getDatabasesPath(), "note.db"),
    version: 2,
    onCreate: (Database db, int version) async {
        await db.execute(
        """
          CREATE TABLE IF NOT EXISTS NOTE(
            id INTEGER PRIMARY KEY,
            data DATETIME NOT NULL,
            situacao INTEGER NOT NULL,
            imagem_fundo TEXT,
            observacao TEXT
          )
        """
      );

      await db.execute(
        """
          CREATE TABLE IF NOT EXISTS CONFIGUSER(
            id INTEGER PRIMARY KEY,
            path_foto TEXT DEFAULT NULL,
            nome TEXT DEFAULT NULL
          )
        """
      );

      await db.rawInsert("""
        INSERT INTO CONFIGUSER (path_foto, nome)
        SELECT '', '' WHERE NOT EXISTS(
          SELECT ID FROM CONFIGUSER WHERE ID = 1
        )
      """);
    },
    onUpgrade: (Database db, int version, int newVersion) async {
      List<Map> columns = await db.rawQuery("PRAGMA TABLE_INFO('NOTE')");
      for (Map item in columns) {
        if (item["name"] == "titulo") {
          await db.execute("ALTER TABLE NOTE DROP COLUMN TITULO");
        }

        if (item["name"] == "cor") {
          await db.execute("ALTER TABLE NOTE DROP COLUMN COR");
          break;
        }
      }

      columns = await db.rawQuery("PRAGMA TABLE_INFO('NOTE')");
      print(columns);
    }
  );
}