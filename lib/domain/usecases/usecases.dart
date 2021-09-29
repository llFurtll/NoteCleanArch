import 'package:note/data/model/anotacao_model.dart';
import '../repositories/irepository.dart';

class UseCases {
  IRepository<AnotacaoModel> repository;

  UseCases({required this.repository});

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
}