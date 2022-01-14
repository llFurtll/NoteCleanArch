import 'package:note/data/datasources/datasource.dart';
import 'package:note/domain/repositories/iconfig_repository.dart';

class ConfigUserRepository implements IConfigRepository {

  DatasourceBase datasourceBase;

  ConfigUserRepository({
    required this.datasourceBase
  });

  @override
  Future<String?> getImage() async {
    return await datasourceBase.getImage();
  }

  @override
  Future<String?> getName() async {
    return await datasourceBase.getName();
  }

  @override
  Future<int?> updateImage({required String pathImage}) async {
    return await datasourceBase.updateImage(pathImage: pathImage);
  }

  @override
  Future<int?> updateName({required String name}) async {
    return await datasourceBase.updateName(name: name);
  }
  
}