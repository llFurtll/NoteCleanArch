import '../entities/atualizacao.dart';
import '../repositories/iatualizacao_repository.dart';

class AtualizacaoUsecase {
  final IAtualizacaoRepository repository;

  const AtualizacaoUsecase(this.repository);

  Future<List<Atualizacao>> findAllByVersao(int versao) async {
    return await repository.findAllByVersao(versao);
  }

  Future<List<Atualizacao>> findAllByVersaoWithoutVisualizacao(int versao) async {
    return repository.findAllByVersaoWithoutVisualizacao(versao);
  }

  Future<int> insertAtualizcao(int versao) async {
    return await repository.insertVisualizacao(versao);
  }

  Future<int> getLastVersion() async {
    return await repository.getLastVersion();
  }
}