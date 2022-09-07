import 'package:flutter_test/flutter_test.dart';

import 'package:note/data/model/anotacao_model.dart';
import 'package:note/test/data/datasource/datasourcetest.dart';
import 'package:note/test/data/repository/crud/repositorytest.dart';
import 'package:note/test/utils/utils.dart';

void main() {
  late DatasourceTest datasourceTest;
  late RepositoryTest repositoryTest;

  setUp(() async {
    datasourceTest = DatasourceTest();
    repositoryTest = RepositoryTest(datasourceBase: datasourceTest);
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
          situacao: 0
        ) as AnotacaoModel);

        assert(update == 1);
      });

      test("Testando o update situacao", () async {
        int? update = await repositoryTest.updateSituacao(anotacao: gerarAnotacao(
          id: 1,
          data: DateTime.now().toIso8601String(),
          imagemFundo: "Legal",
          observacao: "Eu amo flutter",
          situacao: 0
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
            data: DateTime.now().toIso8601String(),
            situacao: 1,
            imagemFundo: "http",
            observacao: "Teste insert"
          ) as AnotacaoModel
        );

        assert(insert != 0);
      });

      test("Removendo o background", () async {
        int? updated = await repositoryTest.removeBackgroundNote(image: "http");
        assert(updated == 2);
      });

      test("find com desc", () async {
        List<AnotacaoModel?> listaAnotacao = await repositoryTest.findWithDesc(desc: "gostei");
        expect(listaAnotacao.length, 2);
      });

    });
}