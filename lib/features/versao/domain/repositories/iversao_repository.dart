import '../entities/versao.dart';

abstract class IVersaoRepository {
  Future<List<Versao>> findAll();
}