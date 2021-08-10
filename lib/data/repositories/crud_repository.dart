import 'package:note/data/datasources/datasource.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/domain/repositories/irepository.dart';

class CrudRepository implements IRepository<AnotacaoModel> {

  DatasourceBase<AnotacaoModel> datasourceBase;

  CrudRepository({required this.datasourceBase});

  @override
  Future<int?> delete({required int id}) async {
      return await datasourceBase.delete(id: id);
  }
  
  @override
  Future<int?> insert({required AnotacaoModel anotacao}) async {
    return await datasourceBase.insert(anotacao: anotacao);
  }
  
  @override
  Future<int?> update({required AnotacaoModel anotacao}) async {
    return await datasourceBase.update(anotacao: anotacao);
  }

  @override
  Future<List<AnotacaoModel?>> findAll() async {
    return await datasourceBase.findAll();
  }

  @override
  Future<AnotacaoModel?> getById({required int id}) async {
    return await datasourceBase.getById(id: id);
  }
}