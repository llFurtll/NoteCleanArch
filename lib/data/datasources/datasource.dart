import '../../domain/entities/anotacao.dart';

abstract class DatasourceBase<T> {
  Future<T> getConnection();

  Future<List<Anotacao>> findAll();

  Future<Anotacao> getById({required int id});

  Future<T> create({required Anotacao anotacaoModel});

  Future<T> update({required int id});

  Future<T> delete({required int id});
}