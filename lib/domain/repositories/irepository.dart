import '../entities/anotacao.dart';

abstract class IRepository<T extends Anotacao> {
  Future<int?> insert({required T anotacao});
  Future<int?> update({required T anotacao});
  Future<int?> updateSituacao({required T anotacao});
  Future<int?> delete({required int id});
  Future<List<T?>> findAll();
  Future<T?> getById({required int id});
  Future<int?> removeBackgroundNote({required String image});
  Future<List<T?>> findWithDesc({String desc = ""});
}