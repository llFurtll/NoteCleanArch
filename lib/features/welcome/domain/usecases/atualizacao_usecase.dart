import '../entities/atualizacao.dart';
import '../repositories/iatualizacao_repository.dart';

class AtualizacaoUsecase {
  final IAtualizacaoRepository repository;

  const AtualizacaoUsecase(this.repository);

  Future<List<Atualizacao>> findAllByVersao(double versao) async {
    return repository.findAllByVersao(versao);
  }

  Future<int> insertAtualizcao(double versao) async {
    return await repository.insertVisualizacao(versao);
  }

  Future<double> getLastVersion() async {
    return await repository.getLastVersion();
  }

  Future<List<double>> getAllVersions() async {
    return await repository.getAllVersions();
  }
}