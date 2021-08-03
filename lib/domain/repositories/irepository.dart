import '../entities/anotacao.dart';

abstract class IRepository<T> {
  Future<T?> insert({required Anotacao anotacao});
  Future<T?> update({required Anotacao anotacao});
  Future<T?> delete({required int id});
  Future<List<Anotacao>> findAll();
  Future<Anotacao> getById({required int id});
}