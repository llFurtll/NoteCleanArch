import 'package:flutter_test/flutter_test.dart';

import '../../../../features/note/data/datasources/sqlite.dart';
import '../../../../features/note/data/repositories/config_repository.dart';
import '../../../../core/utils/init_database.dart';

void main() {
  late SqliteDatasource datasourceTest;
  late ConfigUserRepository repositoryConfigTest;

  setUp(() async {
    await initDatabase(true);
    datasourceTest = SqliteDatasource(test: true);
    repositoryConfigTest = ConfigUserRepository(datasourceBase: datasourceTest);
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