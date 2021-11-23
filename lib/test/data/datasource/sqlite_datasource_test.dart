import 'package:flutter_test/flutter_test.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/test/data/datasource/sqlite.dart';
import 'package:note/test/utils/utils.dart';

void main() {
  late DatasourceTest datasourceTest;
  
  setUp(() async {
    datasourceTest = DatasourceTest();
  });

  group(
    "Testando o datasource",
    () {
      test('Testando o findAll', () async {
        List<AnotacaoModel?> lista = await datasourceTest.findAll();
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
            id: 2,
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
            id: 2,
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

      test("Removendo o background", () async {
        int? update = await datasourceTest.removeBackgroundNote(image: "http");
        assert(update == 2);
      });

      test("Testando o find com desc", () async {
        List<AnotacaoModel?> lista = await datasourceTest.findWithDesc(desc: "teste");
        expect(lista.length, 2);
      }); 
    }
  );
}