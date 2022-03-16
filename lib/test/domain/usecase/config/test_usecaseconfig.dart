import 'package:note/domain/repositories/iconfig_repository.dart';

class UseCaseConfigTest {
  IConfigRepository repository;

  UseCaseConfigTest({required this.repository});

  Future<String?> getImage() async {
    return await repository.getImage();
  }

  Future<String?> getName() async {
    return await repository.getName();
  }

  Future<int?> updateImage({required String pathImage}) async {
    return await repository.updateImage(pathImage: pathImage);
  }

  Future<int?> updateName({required String name}) async {
    return await repository.updateName(name: name);
  }
}