import 'package:flutter_test/flutter_test.dart';

import 'package:note/data/model/anotacao_model.dart';
import 'package:note/test/data/datasource/datasourcetest.dart';
import 'package:note/test/data/repository/crud/repositorytest.dart';
import 'package:note/test/domain/usecase/crud/test_usecases.dart';
import 'package:note/test/utils/utils.dart';

void main() {
  late UseCasesTest useCases;
  late RepositoryTest crudRepository;
  late DatasourceTest datasourceTest;

  setUp(() async {
    datasourceTest = DatasourceTest();
    crudRepository = RepositoryTest(datasourceBase: datasourceTest);
    useCases = UseCasesTest(repository: crudRepository);
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
          situacao: 0
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
          ) as AnotacaoModel
        );

        assert(insert != 0);
      });

      test("Removendo o background", () async {
        int? updated = await useCases.removeBackgroundNote(image: "http");
        assert(updated == 2);
      });

      test("find com desc", () async {
        List<AnotacaoModel?> listaAnotacao = await useCases.findWithDesc(desc: "gostei");
        expect(listaAnotacao.length, 2);
      });

    }
  );
}