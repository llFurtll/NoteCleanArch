import 'package:note/test/data/datasource/datasourcetest.dart';
import 'package:note/test/data/repository/config/repository_configtest.dart';
import 'package:note/test/domain/usecase/config/test_usecaseconfig.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late UseCaseConfigTest useCaseConfigTest;
  late DatasourceTest datasourceTest;
  late RepositoryConfigTest repositoryConfigTest;

  setUp(() {
    datasourceTest = DatasourceTest();
    repositoryConfigTest = RepositoryConfigTest(datasourceBase: datasourceTest);
    useCaseConfigTest =  UseCaseConfigTest(repository: repositoryConfigTest);
  });

  group(
    "Testando os metodos do use case de config",
    () {
      test("Testando o get image", () async {
        String? pathImage = await useCaseConfigTest.getImage();
        assert(pathImage == "https://teste.com.br/teste.jpg");
      });

      test("Testando o get name", () async {
        String? name = await useCaseConfigTest.getName();
        assert(name == "Daniel Melonari");
      });

      test("Testando o update image", () async {
        int? update = await useCaseConfigTest.updateImage(pathImage: "https://teste.com.br/nova_imagem.jpg");
        assert(update == 1);
      });

      test("Testando o update name", () async {
        int? update = await useCaseConfigTest.updateName(name: "Daniel");
        assert(update == 1);
      });
    }
  );
}