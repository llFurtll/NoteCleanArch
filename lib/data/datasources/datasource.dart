import '../../domain/entities/anotacao.dart';

abstract class DatasourceBase<T extends Anotacao> {
  Future<List<T?>> findAll();
  Future<T?> getById({required int id});
  Future<int?> insert({required T anotacao});
  Future<int?> update({required T anotacao});
  Future<int?> delete({required int id});
}