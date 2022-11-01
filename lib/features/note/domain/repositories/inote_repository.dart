import '../entities/note.dart';

abstract class INoteRepository<T extends Note> {
  Future<int?> insert({required T anotacao});
  Future<int?> update({required T anotacao});
  Future<int?> updateSituacao({required T anotacao});
  Future<T?> getById({required int id});
  Future<int?> removeBackgroundNote({required String image});
}