import '../../../../data/datasources/datasource.dart';
import '../../../../domain/repositories/iconfig_repository.dart';

class RepositoryConfigTest implements IConfigRepository{
  DatasourceBase datasourceBase;

  RepositoryConfigTest({
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