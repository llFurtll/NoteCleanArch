import '../datasources/home_datasource.dart';
import '../models/home_anotacao_model.dart';
import '../../domain/entities/home_anotacao.dart';
import '../../domain/repositories/ihome_repository.dart';

class HomeRepositoryImpl implements IHomeRepository {
  final HomeDataSource dataSource;

  HomeRepositoryImpl({required this.dataSource});

  @override
  Future<List<HomeAnotacao>> findAll() async {
    List<HomeAnotacaoModel> result = await dataSource.findAll();
    List<HomeAnotacao> response = [];
    for (var note in result) {
      response.add(HomeAnotacaoModel.fromModel(note));
    }
    
    return response;
  }

  @override
  Future<List<HomeAnotacao>> findWithDesc({String desc = ""}) async {
    List<HomeAnotacaoModel> result = await dataSource.findWithDesc(desc: desc);
    List<HomeAnotacao> response = [];
    for (var note in result) {
      response.add(HomeAnotacaoModel.fromModel(note));
    }
    
    return response;
  }

  Future<int?> deleteById({required int id}) {
    return dataSource.deleteById(id: id);
  }
}