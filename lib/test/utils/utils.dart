import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:note/data/model/anotacao_model.dart';
import 'package:note/domain/entities/anotacao.dart';

Future<Database> inicializeDatabase() async {
  sqfliteFfiInit();
  
  Database db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

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
          path_foto TEXT DEFAULT NULL,
          nome TEXT DEFAULT NULL
        )
      """
    );

    await db.insert("NOTE", inserirAnotacao());
    await db.insert("NOTE", inserirAnotacao());
    await db.insert("CONFIGUSER", inserirConfigUsuario());

    return db;
}

Anotacao gerarAnotacao(
  {int id = 0, String titulo = "", String data = "",
  int situacao = 1, String imagemFundo = "", String observacao = "", String cor = ""}
  ) {
    AnotacaoModel anotacao =  new AnotacaoModel(
      id: id,
      titulo: titulo,
      data: data,
      situacao: situacao,
      imagemFundo: imagemFundo,
      observacao: observacao,
      cor: cor
    );

    return anotacao;
}

Map<String, Object?> inserirAnotacao() {
  Map<String, Object?> insert = Map();

  insert["titulo"] = "teste";
  insert["data"] = DateTime.now().toIso8601String();
  insert["situacao"] = 1;
  insert["imagem_fundo"] = "http";
  insert["observacao"] = "gostei";
  insert["cor"] = "#FFFFFF";

  return insert;
}

Map<String, Object?> inserirConfigUsuario() {
  Map<String, Object?> insert = Map();

  insert["path_foto"] = "https://teste.com.br/teste.jpg";
  insert["nome"] = "Daniel Melonari";

  return insert;
}