import 'package:flutter_test/flutter_test.dart';
import 'package:note/data/datasources/sqlite.dart';
import 'package:note/domain/entities/anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mockito/mockito.dart';

class DatasourceTest extends SqliteDatasource {
  Database db;
  DatasourceTest({required this.db}) : super(db: db);
}

void main() {
  Anotacao gerarAnotacao(
    String titulo, String data, int situacao, String imagemFundo, String observacao
  ) {
    Anotacao anotacao = new Anotacao(
      titulo: titulo,
      data: data,
      situacao: situacao,
      imagemFundo: imagemFundo,
      observacao: observacao
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

    return insert;
  }

  late DatasourceTest datasourceTest;
  late Database db;
  
  sqfliteFfiInit();
  setUp(() async {

    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

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

    await db.insert("NOTE", inserirAnotacao());
    await db.insert("NOTE", inserirAnotacao());

    datasourceTest = DatasourceTest(db: db);
  });

  group(
    "Testando o datasource",
    () {
      test('Testando o findAll', () async {
        List<Anotacao> lista = await datasourceTest.findAll();
        expect(lista.length, 2);
      });

      test('Testando o insert', () async {
        int? insert = await datasourceTest.insert(
          anotacao: gerarAnotacao(
            "Teste do insert do caralho", DateTime.now().toIso8601String(), 1, "http", "Teste insert"
          )
        );

        assert(!insert!.isNaN);
      });
    }
  );

  tearDown(() async {
    await db.close();
  });
}