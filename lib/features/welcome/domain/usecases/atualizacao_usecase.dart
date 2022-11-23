import '../entities/atualizacao.dart';
import '../repositories/iatualizacao_repository.dart';

class AtualizacaoUsecase {
  final IAtualizacaoRepository repository;

  const AtualizacaoUsecase(this.repository);

  Future<List<Atualizacao>> findAllByVersao(double versao) async {
    return repository.findAllByVersao(versao);
  }
}