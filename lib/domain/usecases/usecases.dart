import '../entities/anotacao.dart';
import '../repositories/irepository.dart';

class UseCases {
  IRepository repository;

  UseCases({required this.repository});

  Future<int?> insertUseCase({required Anotacao anotacao}) async {
    return await repository.insert(anotacao: anotacao);
  }

  Future<int?> updateUseCase({required Anotacao anotacao}) async {
    return await repository.update(anotacao: anotacao);
  }
  
  Future<int?> deleteUseCase({required int id}) async {
    return await repository.delete(id: id);
  }

  Future<List<Anotacao>> findAlluseCase({required int id}) async {
    return await repository.findAll();
  }

  Future<Anotacao> getByIdUseCase({required int id}) async {
    return await repository.getById(id: id);
  }
}