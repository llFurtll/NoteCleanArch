import 'package:flutter_test/flutter_test.dart';
import 'package:note/data/datasources/sqlite.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/data/repositories/crud_repository.dart';
import 'package:note/domain/usecases/usecases.dart';
import 'package:note/test/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  late UseCases useCases;
  late CrudRepository crudRepository;
  late SqliteDatasource sqliteDatasource;
  late Database db;

  setUp(() async {
    db = await inicializeDatabase();
    sqliteDatasource = SqliteDatasource(db: db);
    crudRepository = CrudRepository(datasourceBase: sqliteDatasource);
    useCases = UseCases(repository: crudRepository);
  });

  group(
    "Testando os casos de uso",
    () {

      test("Testando o findAlluseCase", () async {
        List<AnotacaoModel?> lista = await useCases.findAlluseCase();
          expect(lista.length, 2);
          expect(lista[0]!.id, 1);
          expect(lista[1]!.id, 2);
      });

      test("Testando o getByIdUseCase", () async {
        AnotacaoModel? anotacao = await useCases.getByIdUseCase(id: 1);
        assert(anotacao != null);
        expect(anotacao!.id, 1);
      });

      test("Testando o updateUseCase", () async {
        int? update = await useCases.updateUseCase(anotacao: gerarAnotacao(
          id: 1,
          data: DateTime.now().toIso8601String(),
          imagemFundo: "Legal",
          observacao: "Eu amo flutter",
          situacao: 0,
          titulo: "Lindo"
        ) as AnotacaoModel);

        assert(update == 1);
      });

       test("Testando o deleteUseCase", () async {
        int? delete = await useCases.deleteUseCase(id: 1);
         assert(delete == 1);
      });

      test("Testando o insert", () async {
        int? insert = await useCases.insertUseCase(
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

    }
  );
}