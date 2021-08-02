import 'package:note/domain/entities/anotacao.dart';
import 'package:note/domain/repositories/irepository.dart';

class CrudRepository implements IRepository {
  @override
  Future<int>? delete<int>({required int id}) {
      return Future.value(null);
  }
  
  @override
  Future<T>? insert<T>({required Anotacao anotacao}) {
    return Future.value(null);
  }
  
  @override
  Future<int>? update<int>({required int id}) {
    return Future.value(null);
  }

  @override
  Future<List<Anotacao>>? findAll() {
    return Future.value(null);
  }

  @override
  Future<Anotacao>? getById({required int id}) {
    return Future.value(null);
  }
}