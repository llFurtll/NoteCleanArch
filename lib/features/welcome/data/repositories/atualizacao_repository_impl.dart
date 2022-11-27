import '../../domain/entities/atualizacao.dart';
import '../../domain/repositories/iatualizacao_repository.dart';
import '../datasources/atualizacao_datasource.dart';

class AtualizacaoRepositoryImpl implements IAtualizacaoRepository {
  final AtualizacaoDataSource dataSource;

  const AtualizacaoRepositoryImpl({required this.dataSource});

  @override
  Future<List<Atualizacao>> findAllByVersao(double versao) async {
    final response = await dataSource.findAllByVersao(versao);
    return response;
  }

  @override
  Future<int> insertVisualizacao(double versao) async {
    return await dataSource.insertVisualizacao(versao);
  }

  @override
  Future<double> getLastVersion() async {
    return await dataSource.getLastVersion();
  }

  @override
  Future<List<double>> getAllVersions() async {
    return await dataSource.getAllVersions();
  }
}