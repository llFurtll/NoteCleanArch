import 'package:note/data/datasources/datasource.dart';
import 'package:note/domain/entities/anotacao.dart';
import 'package:note/domain/repositories/irepository.dart';

class CrudRepository implements IRepository<dynamic> {

  DatasourceBase datasourceBase;

  CrudRepository({required this.datasourceBase});

  @override
  Future<int?> delete({required int id}) async {
      return await datasourceBase.delete(id: id);
  }
  
  @override
  Future<int?> insert({required Anotacao anotacao}) async {
    return await datasourceBase.insert(anotacao: anotacao);
  }
  
  @override
  Future<int?> update({required Anotacao anotacao}) async {
    return await datasourceBase.update(anotacao: anotacao);
  }

  @override
  Future<List<Anotacao>> findAll() async {
    return await datasourceBase.findAll();
  }

  @override
  Future<Anotacao> getById({required int id}) async {
    return await datasourceBase.getById(id: id);
  }
}