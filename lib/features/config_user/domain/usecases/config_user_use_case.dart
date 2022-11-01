import '../repositories/iconfig_user_repository.dart';

class ConfigUserUseCase {
  final IConfigUserRepository repository;

  ConfigUserUseCase({required this.repository});

  Future<int?> updateImage({required String pathImage}) async {
    return await repository.updateImage(pathImage: pathImage);
  }

  Future<String?> getImage() async {
    return await repository.getImage();
  }

  Future<int?> updateName({required String name}) async {
    return await repository.updateName(name: name);
  }

  Future<String?> getName() async {
    return await repository.getName();
  }
}