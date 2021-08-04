import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:note/data/datasources/sqlite.dart';
import 'package:note/domain/entities/anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatasourceTest extends SqliteDatasource {}

void main() {
  Anotacao gerarAnotacao(
    int id, String titulo, DateTime data, bool situacao, String imagemFundo, String observacao
  ) {
    Anotacao anotacao = new Anotacao(
      id: id,
      titulo: titulo,
      data: data,
      situacao: situacao,
      imagemFundo: imagemFundo,
      observacao: observacao
    );

    return anotacao;
  }

  late DatasourceTest datasourceTest;

  setUp(() {
    datasourceTest = DatasourceTest();
  });

  group(
    "Testando o datasource",
    () {
      sqfliteFfiInit();
      test('Testando o findAll', () async {
        List<Anotacao> lista = [];
        var db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

        lista.add(
          gerarAnotacao(1, "teste", DateTime.now(), true, "teste", "legal")
        );

        lista.add(
          gerarAnotacao(2, "teste", DateTime.now(), true, "teste", "legal")
        );

        when(await datasourceTest.getConnection()).thenReturn(db);
        when(await datasourceTest.findAll()).thenReturn(lista);

        List<Anotacao> novaLista = await datasourceTest.findAll();

        expect(lista.length, novaLista.length);
      });
    }
  );
}