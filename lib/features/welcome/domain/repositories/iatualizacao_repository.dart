import '../entities/atualizacao.dart';

abstract class IAtualizacaoRepository {
  Future<List<Atualizacao>> findAllByVersao(double versao);
  Future<int> insertVisualizacao(double versao);
  Future<double> getLastVersion();
  Future<List<double>> getAllVersions();
}