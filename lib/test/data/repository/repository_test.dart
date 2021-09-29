
import 'package:note/data/datasources/datasource.dart';
import 'package:note/data/datasources/sqlite.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/data/repositories/crud_repository.dart';
import 'package:note/test/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

class RepositoryTest extends CrudRepository {
  RepositoryTest(DatasourceBase<AnotacaoModel> datasourceBase) : super(datasourceBase: datasourceBase);
}

void main() {
  late SqliteDatasource sqliteDatasource;
  late RepositoryTest repositoryTest;
  late Database db;

  setUp(() async {
    db = await inicializeDatabase();
    sqliteDatasource = SqliteDatasource(db: db);
    repositoryTest = RepositoryTest(sqliteDatasource);
  });

  group(
    "Testando os metodos do repository",
    () {
      test("Testando o findAll", () async {
        List<AnotacaoModel?> lista = await repositoryTest.findAll();
        expect(lista.length, 2);
        expect(lista[0]!.id, 2);
        expect(lista[1]!.id, 1);
      });

      test("Testando o getById", () async {
        AnotacaoModel? anotacaoModel = await repositoryTest.getById(id: 1);
        assert(anotacaoModel != null);
        expect(anotacaoModel!.id, 1);
      });

      test("Testando o update", () async {
        int? update = await repositoryTest.update(anotacao: gerarAnotacao(
          id: 1,
          data: DateTime.now().toIso8601String(),
          imagemFundo: "Legal",
          observacao: "Eu amo flutter",
          situacao: 0,
          titulo: "Lindo"
        ) as AnotacaoModel);

        assert(update == 1);
      });

      test("Testando o update situacao", () async {
        int? update = await repositoryTest.updateSituacao(anotacao: gerarAnotacao(
          id: 1,
          data: DateTime.now().toIso8601String(),
          imagemFundo: "Legal",
          observacao: "Eu amo flutter",
          situacao: 0,
          titulo: "Lindo"
        ) as AnotacaoModel);

        assert(update == 1);
      });

      test("Testando o delete", () async {
        int? delete = await repositoryTest.delete(id: 1);
         assert(delete == 1);
      });

      test("Testando o insert", () async {
        int? insert = await repositoryTest.insert(
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

      tearDownAll(() async {
        await db.close();
      });

    });
}