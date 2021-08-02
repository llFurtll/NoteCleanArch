import '../entities/anotacao.dart';
import '../repositories/irepository.dart';

class UseCases {
  IRepository repository;

  UseCases({required this.repository});

  Future<int>? insertUseCase<int>({required Anotacao anotacao}) {
    return repository.insert(anotacao: anotacao);
  }

  Future<int>? updateUseCase<int>({required int id}) {
    return repository.update(id: id);
  }
  
  Future<int>? deleteUseCase<int>({required int id}) {
    return repository.delete(id: id);
  }

  Future<List<Anotacao>>? findAlluseCase<T>({required int id}) {
    return repository.findAll();
  }

  Future<Anotacao>? getByIdUseCase<T>({required int id}) {
    return repository.getById(id: id);
  }
}