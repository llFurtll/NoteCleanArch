import '../../domain/entities/atualizacao.dart';
import '../../domain/repositories/iatualizacao_repository.dart';
import '../datasources/atualizacao_datasource.dart';

class AtualizacaoRepositoryImpl implements IAtualizacaoRepository {
  final AtualizacaoDataSource dataSource;

  const AtualizacaoRepositoryImpl({required this.dataSource});

  @override
  Future<List<Atualizacao>> findAllByVersao(int versao) async {
    return await dataSource.findAllByVersao(versao);
  }

  @override
  Future<List<Atualizacao>> findAllByVersaoWithoutVisualizacao(int versao) async {
    final response = await dataSource.findAllByVersaoWithoutVisualizacao(versao);
    return response;
  }

  @override
  Future<int> insertVisualizacao(int versao) async {
    return await dataSource.insertVisualizacao(versao);
  }

  @override
  Future<int> getLastVersion() async {
    return await dataSource.getLastVersion();
  }
}