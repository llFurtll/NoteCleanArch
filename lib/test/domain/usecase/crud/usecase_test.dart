import 'package:flutter_test/flutter_test.dart';

import '../../../../features/note/data/model/anotacao_model.dart';
import '../../../../features/note/data/datasources/sqlite.dart';
import '../../../../features/note/data/repositories/crud_repository.dart';
import '../../../../features/note/domain/usecases/crud_usecases.dart';
import '../../../../core/utils/init_database.dart';
import '../../../../core/utils/utils_test.dart';

void main() {
  late CrudUseCases useCases;
  late CrudRepository crudRepository;
  late SqliteDatasource datasourceTest;

  setUp(() async {
    await initDatabase(true);
    datasourceTest = SqliteDatasource(test: true);
    crudRepository = CrudRepository(datasourceBase: datasourceTest);
    useCases = CrudUseCases(repository: crudRepository);
  });

  group(
    "Testando os casos de uso",
    () {

      test("Testando o findAlluseCase", () async {
        List<AnotacaoModel?> lista = await useCases.findAlluseCase();
          expect(lista.length, 2);
          expect(lista[0]!.id, 2);
          expect(lista[1]!.id, 1);
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
          situacao: 0
        ) as AnotacaoModel);

        assert(update == 1);
      });

      test("Testando o updateSituacaoUseCase", () async {
        int? update = await useCases.updateSituacaoUseCase(anotacao: gerarAnotacao(
          id: 1,
          data: DateTime.now().toIso8601String(),
          imagemFundo: "Legal",
          observacao: "Eu amo flutter",
          situacao: 0,
          titulo: "Teste"
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
            data: DateTime.now().toIso8601String(),
            situacao: 1,
            imagemFundo: "http",
            observacao: "Teste insert",
            titulo: "Teste"
          ) as AnotacaoModel
        );

        assert(insert != 0);
      });

      test("Removendo o background", () async {
        int? updated = await useCases.removeBackgroundNote(image: "http");
        assert(updated == 2);
      });

      test("find com desc", () async {
        List<AnotacaoModel?> listaAnotacao = await useCases.findWithDesc(desc: "teste desc");
        expect(listaAnotacao.length, 2);
      });
    }
  );
}