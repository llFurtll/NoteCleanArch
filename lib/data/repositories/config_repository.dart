import 'package:note/data/datasources/datasource.dart';
import 'package:note/domain/repositories/iconfig_repository.dart';

class ConfigRepository extends IConfigRepository {

  DatasourceBase datasourceBase;

  ConfigRepository({
    required this.datasourceBase
  });

  @override
  Future<String?> getImage({required int id}) {
    // TODO: implement getImage
    throw UnimplementedError();
  }

  @override
  Future<String?> getName({required int id}) {
    // TODO: implement getName
    throw UnimplementedError();
  }

  @override
  Future<int?> insertImage() {
    // TODO: implement insertImage
    throw UnimplementedError();
  }

  @override
  Future<int?> insertName({required String text}) {
    // TODO: implement insertName
    throw UnimplementedError();
  }

  @override
  Future<int?> updateImage({required int id}) {
    // TODO: implement updateImage
    throw UnimplementedError();
  }

  @override
  Future<int?> updateName({required String text}) {
    // TODO: implement updateName
    throw UnimplementedError();
  }
  
}