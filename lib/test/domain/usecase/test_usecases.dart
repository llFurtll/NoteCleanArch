import 'package:note/data/model/anotacao_model.dart';
import 'package:note/domain/repositories/irepository.dart';

class UseCasesTest {
  IRepository<AnotacaoModel> repository;

  UseCasesTest({required this.repository});

  Future<int?> insertUseCase({required AnotacaoModel anotacao}) async {
    return await repository.insert(anotacao: anotacao);
  }

  Future<int?> updateUseCase({required AnotacaoModel anotacao}) async {
    return await repository.update(anotacao: anotacao);
  }
  
  Future<int?> deleteUseCase({required int id}) async {
    return await repository.delete(id: id);
  }

  Future<List<AnotacaoModel?>> findAlluseCase() async {
    return await repository.findAll();
  }

  Future<AnotacaoModel?> getByIdUseCase({required int id}) async {
    return await repository.getById(id: id);
  }

  Future<int?> updateSituacaoUseCase({required AnotacaoModel anotacao}) async {
    anotacao.situacao = anotacao.situacao == 1 ? 0 : 1;
    return await repository.updateSituacao(anotacao: anotacao);
  }

  Future<int?> removeBackgroundNote({required String image}) async {
    int? update = await repository.removeBackgroundNote(image: image);
    return update;
  }

  Future<List<AnotacaoModel?>> findWithDesc({String desc = ""}) async {
    return await repository.findWithDesc(desc: desc);
  }
}