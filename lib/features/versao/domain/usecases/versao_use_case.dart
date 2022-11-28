import '../entities/versao.dart';
import '../repositories/iversao_repository.dart';

class VersaoUseCase {
  final IVersaoRepository repository;

  const VersaoUseCase(this.repository);

  Future<List<Versao>> findAll() async {
    return await repository.findAll();
  }
}