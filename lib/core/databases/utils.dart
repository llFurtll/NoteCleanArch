import 'package:sqflite/sqflite.dart';

import 'versoes.dart';

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

Future<void> _createTable(Database db, String table, Map<String, String> columns) async {
  String sql = "CREATE TABLE IF NOT EXISTS $table (\n";
  columns.keys.forEach((key) {
    sql += "$key ${columns[key]}";
  });
  await db.execute(sql);
}

Future<void> createAllTables(Database db) async {
  await _createTable(db, "NOTE", {
    "id": "INTEGER PRIMARY KEY,",
    "titulo": "TEXT NOT NULL,",
    "data": "DATETIME NOT NULL,",
    "situacao": "INTEGER NOT NULL,",
    "imagem_fundo": "TEXT,",
    "observacao": "TEXT,",
    "ultima_atualizacao": "DATETIME NOT NULL)",
  });

  await _createTable(db, "CONFIGUSER", {
    "id": "INTEGER PRIMARY KEY,",
    "path_foto": "TEXT DEFAULT NULL,",
    "nome": "TEXT DEFAULT NULL)"
  });

  await _createTable(db, "CONFIGAPP", {
    "id": "INTEGER PRIMARY KEY,",
    "identificador": "TEXT NOT NULL,",
    "valor": "INT NOT NULL,",
    "modulo": "TEXT NOT NULL)",
  });

  await _createTable(db, "VISUALIZACAO", {
    "id": "INTEGER PRIMARY KEY,",
    "id_usuario": "INTEGER NOT NULL,",
    "id_versao": "INTEGER NOT NULL)"
  });

  await _createTable(db, "ATUALIZACAO", {
    "id": "INTEGER PRIMARY KEY,",
    "versao": "REAL NOT NULL,",
    "cabecalho": "TEXT NOT NULL,",
    "descricao": "TEXT NOT NULL,",
    "imagem": "TEXT NOT NULL)"
  });
}

Future<void> insertRegistros(Database db) async {
  await db.rawInsert("""
    INSERT INTO CONFIGUSER (path_foto, nome)
    SELECT '', '' WHERE NOT EXISTS(
      SELECT ID FROM CONFIGUSER WHERE ID = 1
    )
  """);

  await Future.value()
    .then((_) {
      versoes.forEach((item) async {
        await db.rawInsert(
          """
            INSERT INTO ATUALIZACAO (id, versao, cabecalho, descricao, imagem)
            SELECT
              ${item['id']},
              ${item['versao']},
              '${item['cabecalho']}',
              '${item['descricao']}',
              '${item['imagem']}'
            WHERE NOT EXISTS (
              SELECT ID FROM ATUALIZACAO WHERE ID = ${item['id']}
            )
          """
        );
      });
    });

  await _createConfigByModulo(db);
}

Future<void> updateTables(Database db) async {
  bool existeColunaUltimaAtualizacao = false;
  List<Map> columns = await db.rawQuery("PRAGMA TABLE_INFO('NOTE')");

  for (Map item in columns) {
    if (item["name"] == "cor") {
      await _createTable(db, "NEW_NOTE", {
        "id": "INTEGER PRIMARY KEY,",
        "titulo": "TEXT NOT NULL,",
        "data": "DATETIME NOT NULL,",
        "situacao": "INTEGER NOT NULL,",
        "imagem_fundo": "TEXT,",
        "observacao": "TEXT)"
      });

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