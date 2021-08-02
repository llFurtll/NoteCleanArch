import '../entities/anotacao.dart';

abstract class IRepository {
  Future<T>? insert<T>({required Anotacao anotacao});
  Future<T>? update<T>({required T id});
  Future<T>? delete<T>({required T id});
  Future<List<Anotacao>>? findAll();
  Future<Anotacao>? getById({required int id});
}