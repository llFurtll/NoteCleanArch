import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'utils_test.dart';

Future<void> initDatabase(bool test) async {
  if (test) {
    sqfliteFfiInit();
    await databaseFactoryFfi.openDatabase(inMemoryDatabasePath, options: OpenDatabaseOptions(
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      version: 1
    ));
  } else {
    await openDatabase(
      join(await getDatabasesPath(), "note.db"),
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade
    );
  }
}

Future<Database> getDatabase(bool test) async {
  Database _db;
  if (test) {
    sqfliteFfiInit();
    _db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await _db.insert("NOTE", inserirAnotacao());
    await _db.insert("NOTE", inserirAnotacao());
    await _db.update("CONFIGUSER", updateConfigUser());
  } else {
    _db = await openDatabase(join(await getDatabasesPath(), "note.db"));
  }

  return _db;
}

void _onCreate(Database db, int version) async {
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
}

void _onUpgrade(Database db, int version, int newVersion) async {
  List<Map> columns = await db.rawQuery("PRAGMA TABLE_INFO('NOTE')");
  for (Map item in columns) {
    if (item["name"] == "cor") {
      await db.execute(
        """
          CREATE TABLE IF NOT EXISTS NEW_NOTE(
            id INTEGER PRIMARY KEY,
            titulo TEXT NOT NULL,
            data DATETIME NOT NULL,
            situacao INTEGER NOT NULL,
            imagem_fundo TEXT,
            observacao TEXT
          )
      """
      );

      await db.rawInsert("""
          INSERT INTO NEW_NOTE (ID, TITULO, DATA, SITUACAO, IMAGEM_FUNDO, OBSERVACAO)
          SELECT ID, TITULO, DATA, SITUACAO, IMAGEM_FUNDO, OBSERVACAO FROM NOTE
        """
      );

      await db.execute("DROP TABLE IF EXISTS NOTE");
      await db.execute("ALTER TABLE NEW_NOTE RENAME TO NOTE");
      break;
    }
  }
}