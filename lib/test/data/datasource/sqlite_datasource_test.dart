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
    {int id = 0, String titulo = "", String data = "",
    int situacao = 1, String imagemFundo = "", String observacao = ""}
  ) {
    Anotacao anotacao = new Anotacao(
      id: id,
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

      test("Testando o getById", () async {
        Anotacao anotacao = await datasourceTest.getById(id: 2);
        assert(anotacao.id == 2);
      });

      test('Testando o insert', () async {
        int? insert = await datasourceTest.insert(
          anotacao: gerarAnotacao(
            titulo: "Teste do insert",
            data: DateTime.now().toIso8601String(),
            situacao: 1,
            imagemFundo: "http",
            observacao: "Teste insert"
          )
        );

        assert(insert != 0);
      });

      test("Testando o update", () async {
        int? update = await datasourceTest.update(
          anotacao: gerarAnotacao(
            id: 3,
            titulo: "Daniel",
            data: DateTime.now().toIso8601String(),
            situacao: 0,
            imagemFundo: "https",
            observacao: "Daniel e lindo!"
          )
        );

        assert(update == 1);
      });

      test("Testando o delete", () async {
        int? delete = await datasourceTest.delete(id: 1);
        assert(delete == 1);
      });

      tearDownAll(() async {
        await db.close();
      });
    }
  );
}