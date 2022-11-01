import '../../domain/entities/anotacao.dart';

abstract class DatasourceBase<T extends Anotacao> {
  Future<T?> getById({required int id});
  Future<int?> insert({required T anotacao});
  Future<int?> update({required T anotacao});
  Future<int?> updateSituacao({required T anotacao});
  Future<int?> removeBackgroundNote({required String image});
}