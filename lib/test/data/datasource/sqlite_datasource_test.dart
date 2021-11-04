import 'package:flutter_test/flutter_test.dart';
import 'package:note/data/datasources/sqlite.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/test/utils/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

class DatasourceTest extends SqliteDatasource {
  Database db;
  DatasourceTest({required this.db}) : super(db: db);
}

void main() {
  late DatasourceTest datasourceTest;
  late Database db;  
  
  setUp(() async {
    db = await inicializeDatabase();
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
            observacao: "Teste insert",
            cor: "#FFFFFF"
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
            observacao: "Daniel e lindo!",
            cor: "#FFFFFF"
          ) as AnotacaoModel
        );

        assert(update == 1);
      });

      test("Testando o updateSituacao", () async {
        int? update = await datasourceTest.updateSituacao(
          anotacao: gerarAnotacao(
            id: 3,
            titulo: "Daniel",
            data: DateTime.now().toIso8601String(),
            situacao: 0,
            imagemFundo: "https",
            observacao: "Daniel e lindo!",
            cor: "#FFFFFF"
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