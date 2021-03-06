import '../../data/datasources/datasource.dart';
import '../../data/model/anotacao_model.dart';
import '../../domain/repositories/irepository.dart';

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

  @override
  Future<int?> updateSituacao({required AnotacaoModel anotacao}) async {
    return await datasourceBase.updateSituacao(anotacao: anotacao);
  }

  @override
  Future<int?> removeBackgroundNote({required String image}) async {
    int? update = await datasourceBase.removeBackgroundNote(image: image);
    return update;
  }

  @override
  Future<List<AnotacaoModel?>> findWithDesc({String desc = ""}) async {
    return await datasourceBase.findWithDesc(desc: desc);
  }
}