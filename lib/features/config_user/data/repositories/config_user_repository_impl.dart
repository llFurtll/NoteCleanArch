import '../datasources/config_user_datasource.dart';
import '../../domain/repositories/iconfig_user_repository.dart';

class ConfigUserRepositoryImpl implements IConfigUserRepository {
  final ConfigUserDataSource dataSource;

  ConfigUserRepositoryImpl({ required this.dataSource });
  
  @override
  Future<String?> getImage() async {
    return await dataSource.getImage();
  }

  @override
  Future<String?> getName() async {
    return await dataSource.getName();
  }

  @override
  Future<int?> updateImage({required String pathImage}) async {
    return await dataSource.updateImage(pathImage: pathImage);
  }

  @override
  Future<int?> updateName({required String name}) async {
    return await dataSource.updateName(name: name);
  }
}