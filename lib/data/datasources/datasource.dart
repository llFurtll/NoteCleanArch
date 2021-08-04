import '../../domain/entities/anotacao.dart';

abstract class DatasourceBase<T> {
  Future<T> getConnection();
  Future<List<Anotacao>> findAll();
  Future<Anotacao> getById({required int id});
  Future<T?> insert({required Anotacao anotacao});
  Future<T?> update({required Anotacao anotacao});
  Future<T?> delete({required int id});
}