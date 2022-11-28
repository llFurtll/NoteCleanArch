import '../../domain/entities/versao.dart';
import '../../domain/repositories/iversao_repository.dart';
import '../datasources/versao_datasource.dart';

class VersaoRepositoryImpl implements IVersaoRepository {
  final VersaoDataSource dataSource;

  const VersaoRepositoryImpl({required this.dataSource});

  @override
  Future<List<Versao>> findAll() async {
    return await dataSource.findAll();
  }
}