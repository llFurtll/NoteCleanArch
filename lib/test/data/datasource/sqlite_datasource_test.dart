import 'package:flutter_test/flutter_test.dart';

import 'datasourcetest.dart';

import '../../../features/note/data/model/anotacao_model.dart';
import '../../utils/utils.dart';

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
            data: DateTime.now().toIso8601String(),
            situacao: 1,
            imagemFundo: "http",
            observacao: "Teste insert",
            titulo: "Teste"
          ) as AnotacaoModel
        );

        assert(insert != 0);
      });

      test("Testando o update", () async {
        int? update = await datasourceTest.update(
          anotacao: gerarAnotacao(
            id: 2
            data: DateTime.now().toIso8601String(),
            situacao: 0,
            imagemFundo: "https",
            observacao: "Daniel!",
            titulo: "Teste Update"
          ) as AnotacaoModel
        );

        assert(update == 1);
      });

      test("Testando o updateSituacao", () async {
        int? update = await datasourceTest.updateSituacao(
          anotacao: gerarAnotacao(
            id: 2
            data: DateTime.now().toIso8601String(),
            situacao: 0,
            imagemFundo: "https",
            observacao: "Daniel!"
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
        List<AnotacaoModel?> lista = await datasourceTest.findWithDesc(desc: "teste desc");
        expect(lista.length, 2);
      }); 

      test("Testando o get image", () async {
        String? pathImage = await datasourceTest.getImage();
        assert(pathImage == "https://teste.com.br/teste.jpg");
      });

      test("Testando o get name", () async {
        String? name = await datasourceTest.getName();
        assert(name == "Daniel Melonari");
      });

      test("Testando o update image", () async {
        int? update = await datasourceTest.updateImage(pathImage: "https://teste.com.br/nova_imagem.jpg");
        assert(update == 1);
      });

      test("Testando o update name", () async {
        int? update = await datasourceTest.updateName(name: "Daniel");
        assert(update == 1);
      });
    }
  );
}