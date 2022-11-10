import 'package:sqflite/sqflite.dart';

import '../../../../core/utils/init_database.dart';
import '../models/home_anotacao_model.dart';

abstract class HomeDataSource {
  Future<List<HomeAnotacaoModel>> findAll();
  Future<List<HomeAnotacaoModel>> findWithDesc({String desc = ""});
  Future<int?> deleteById({required int id});
}

class HomeDataSourceImpl implements HomeDataSource {

  late Database _db;

  Future<void> getConnection() async {
    _db = await getDatabase();
  }

  Future<void> closeConnection() async {
    await _db.close();
  }

  @override
  Future<List<HomeAnotacaoModel>> findAll() async {
    await getConnection();

    List<HomeAnotacaoModel> listAnotacao = [];
    
    List<Map> listNote = await _db.rawQuery("SELECT ID, TITULO, DATA, IMAGEM_FUNDO FROM NOTE WHERE SITUACAO = 1 ORDER BY DATA DESC");

    listNote.forEach((elemento) {
      listAnotacao.add(HomeAnotacaoModel.fromJson(elemento));
    });

    await closeConnection();

    return listAnotacao;
  }

  @override
  Future<List<HomeAnotacaoModel>> findWithDesc({String desc = ""}) async {
    await getConnection();

    List<HomeAnotacaoModel> listAnotacao = [];

    List<Map> listNote = await _db.rawQuery("SELECT ID, TITULO, DATA, IMAGEM_FUNDO FROM NOTE WHERE SITUACAO = 1 AND TITULO LIKE '%$desc%' ORDER BY DATA DESC");

    listNote.forEach((elemento) {
      listAnotacao.add(HomeAnotacaoModel.fromJson(elemento));
    });

    await closeConnection();

    return listAnotacao;

  }

  Future<int?> deleteById({required int id}) async {
    await getConnection();

    int? delete;

    delete = await _db.rawDelete(
      "DELETE FROM NOTE WHERE ID = ?", [id]
    );

    await closeConnection();

    return delete;
  }
}