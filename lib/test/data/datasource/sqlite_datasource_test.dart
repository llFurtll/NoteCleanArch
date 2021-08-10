import 'package:flutter_test/flutter_test.dart';
import 'package:note/data/datasources/sqlite.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/test/utils/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatasourceTest extends SqliteDatasource {
  Database db;
  DatasourceTest({required this.db}) : super(db: db);
}

void main() {
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
        List<AnotacaoModel> lista = await datasourceTest.findAll();
        expect(lista.length, 2);
      });

      test("Testando o getById", () async {
        AnotacaoModel anotacao = await datasourceTest.getById(id: 2);
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
          ) as AnotacaoModel
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
          ) as AnotacaoModel
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