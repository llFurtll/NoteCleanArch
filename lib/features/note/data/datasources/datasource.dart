import '../../domain/entities/anotacao.dart';

abstract class DatasourceBase<T extends Anotacao> {
  Future<List<T?>> findAll();
  Future<T?> getById({required int id});
  Future<int?> insert({required T anotacao});
  Future<int?> update({required T anotacao});
  Future<int?> delete({required int id});
  Future<int?> updateSituacao({required T anotacao});
  Future<int?> removeBackgroundNote({required String image});
  Future<List<T?>> findWithDesc({String desc = ""});
  Future<String?> getImage();
  Future<String?> getName();
  Future<int?> updateImage({required String pathImage});
  Future<int?> updateName({required String name});
}