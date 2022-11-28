import '../entities/atualizacao.dart';

abstract class IAtualizacaoRepository {
  Future<List<Atualizacao>> findAllByVersaoWithoutVisualizacao(int versao);
  Future<int> insertVisualizacao(int versao);
  Future<int> getLastVersion();
  Future<List<Atualizacao>> findAllByVersao(int versao);
}