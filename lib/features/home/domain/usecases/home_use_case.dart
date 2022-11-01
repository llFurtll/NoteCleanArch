import '../repositories/ihome_repository.dart';
import '../entities/home_anotacao.dart';

class HomeUseCase {
  final IHomeRepository repository;

  HomeUseCase({required this.repository});

  Future<List<HomeAnotacao>> findAll() async {
    return await repository.findAll();
  }

  Future<List<HomeAnotacao>> findWithDesc({String desc = ""}) async {
    return await repository.findWithDesc(desc: desc);
  }

  Future<int?> deleteById({required int id}) async {
    return await repository.deleteById(id: id);
  }
}