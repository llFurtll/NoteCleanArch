import '../entities/note.dart';

abstract class INoteRepository {
  Future<int?> insert({required Note note});
  Future<int?> update({required Note note});
  Future<int?> updateSituacao({required Note note});
  Future<Note> getById({required int id});
  Future<int?> removeBackgroundNote({required String image});
}