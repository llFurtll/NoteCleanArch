import 'package:note/test/data/datasource/datasourcetest.dart';
import 'package:note/test/data/repository/config/repository_configtest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DatasourceTest datasourceTest;
  late RepositoryConfigTest repositoryConfigTest;

  setUp(() async {
    datasourceTest = DatasourceTest();
    repositoryConfigTest = RepositoryConfigTest(datasourceBase: datasourceTest);
  });

  group(
    "Testando os metodos do repository config",
    () {
      test("Testando o get image", () async {
        String? pathImage = await repositoryConfigTest.getImage();
        assert(pathImage == "https://teste.com.br/teste.jpg");
      });

      test("Testando o get name", () async {
        String? name = await repositoryConfigTest.getName();
        assert(name == "Daniel Melonari");
      });

      test("Testando o update image", () async {
        int? update = await repositoryConfigTest.updateImage(pathImage: "https://teste.com.br/nova_imagem.jpg");
        assert(update == 1);
      });

      test("Testando o update name", () async {
        int? update = await repositoryConfigTest.updateName(name: "Daniel");
        assert(update == 1);
      });
    }
  );
}