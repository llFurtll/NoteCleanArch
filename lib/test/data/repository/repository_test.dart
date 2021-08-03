import 'package:flutter_test/flutter_test.dart';
import 'package:note/data/datasources/datasource.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/domain/entities/anotacao.dart';
import 'package:note/domain/repositories/irepository.dart';
import 'package:mockito/mockito.dart';

class RepositoryTeste extends Mock implements IRepository<dynamic> {
  DatasourceBase datasourceBase;

  RepositoryTeste({required this.datasourceBase});
}

class DataSourceTeste extends Mock implements DatasourceBase<dynamic> {}

void main() {
  late RepositoryTeste repositoryTeste;
  late DataSourceTeste dataSourceTeste;

  setUp(() {
    dataSourceTeste = DataSourceTeste();
    repositoryTeste = RepositoryTeste(datasourceBase: dataSourceTeste);
  });

  group("Testando o repository", () {
    test("Testando o findAll", () async {
      List<Anotacao> listaAnotacao = [];

      listaAnotacao.add(new AnotacaoModel(
          id: 1, titulo: "Teste", data: DateTime.now(), situacao: false, imagemFundo: "", observacao: ""
        )
      );

      listaAnotacao.add(new AnotacaoModel(
          id: 2, titulo: "Outro", data: DateTime.now(), situacao: false, imagemFundo: "", observacao: ""
        )
      );

      when(dataSourceTeste.findAll()).thenReturn(Future.value(listaAnotacao));
      //

      List<Anotacao> novaLista = await repositoryTeste.findAll();

      verify(dataSourceTeste.findAll()).called(1);
      expect(novaLista.length, listaAnotacao.length);
    });

  });
}