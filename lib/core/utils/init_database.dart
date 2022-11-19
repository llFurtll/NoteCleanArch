import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> initDatabase() async {
  await openDatabase(
    join(await getDatabasesPath(), "note.db"),
    version: 2,
    onCreate: _onCreate,
    onUpgrade: _onUpgrade
  );
}

Future<Database> getDatabase() async {
  return await openDatabase(join(await getDatabasesPath(), "note.db"));
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
        observacao TEXT,
        ultima_atualizacao DATETIME NOT NULL
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

  await db.execute(
    """
      CREATE TABLE IF NOT EXISTS CONFIGAPP(
        id INTEGER PRIMARY KEY,
        identificador TEXT NOT NULL,
        valor INT NOT NULL,
        modulo TEXT NOT NULL
      )
    """
  );

  await _createConfigByModulo(db);
}

void _onUpgrade(Database db, int version, int newVersion) async {
  bool existeColunaUltimaAtualizacao = false;
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
    }

    if (item["name"] == "ultima_atualizacao") {
      existeColunaUltimaAtualizacao = true;
    }
  }

  if (!existeColunaUltimaAtualizacao) {
    await db.execute("ALTER TABLE NOTE ADD ultima_atualizacao DATETIME NOT NULL");
  }
}

Future<void> _createConfigByModulo(Database db) async {
  Map<String, List<String>> configs = {};

  configs["NOTE"] = [
    "MOSTRAREVERTERPRODUZIRALTERACOES",
    "MOSTRANEGRITO",
    "MOSTRAITALICO",
    "MOSTRASUBLINHADO",
    "MOSTRARISCADO",
    "MOSTRAALINHAMENTOESQUERDA",
    "MOSTRAALINHAMENTOCENTRO",
    "MOSTRAALINHAMENTODIREITA",
    "MOSTRAJUSTIFICADO",
    "MOSTRATABULACAODIREITA",
    "MOSTRATABULACAOESQUERDA",
    "MOSTRAESPACAMENTOLINHAS",
    "MOSTRACORLETRA",
    "MOSTRACORFUNDOLETRA",
    "MOSTRALISTAPONTO",
    "MOSTRALINHANUMERICA",
    "MOSTRALINK",
    "MOSTRAFOTO",
    "MOSTRAAUDIO",
    "MOSTRAVIDEO",
    "MOSTRATABELA",
    "MOSTRASEPARADOR"
  ];

  configs["APP"] = [
    "AUTOSAVE"
  ];

  for (String modulo in configs.keys) {
    List<String>? items = configs[modulo];
    for (String item in items!) {
      await db.execute(
        """
          INSERT INTO CONFIGAPP (modulo, identificador, valor)
          SELECT '$modulo', '$item', ${item == 'AUTOSAVE' ? '0' : '1'} WHERE NOT EXISTS (
            SELECT ID FROM CONFIGAPP WHERE modulo = '$modulo' AND identificador = '$item'
          )
        """
      );
    }
  }
}