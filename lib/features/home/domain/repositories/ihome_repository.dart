import '../entities/home_anotacao.dart';

abstract class IHomeRepository {
  Future<List<HomeAnotacao>> findAll();
  Future<List<HomeAnotacao>> findWithDesc({String desc = ""});
  Future<int?> deleteById({required int id});
}