import 'package:note/data/datasources/datasource.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/domain/repositories/irepository.dart';
import 'package:note/test/data/datasource/sqlite.dart';

class RepositoryTest implements IRepository<AnotacaoModel> {

  DatasourceBase<AnotacaoModel> datasourceBase;

  RepositoryTest({required this.datasourceBase});

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

  Future<int?> removeBackgroundNote({required String image}) async {
    int? update = await (datasourceBase as DatasourceTest).removeBackgroundNote(image: image);
    return update;
  }

  Future<List<AnotacaoModel?>> findWithDesc({String desc = ""}) async {
    return await (datasourceBase as DatasourceTest).findWithDesc(desc: desc);
  }
  
}