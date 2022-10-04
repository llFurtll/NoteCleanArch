import '../../domain/repositories/iconfig_repository.dart';

class ConfigUserUseCases {
  IConfigRepository configRepository;

  ConfigUserUseCases({required this.configRepository});

  Future<String?> getImage() async {
    return await configRepository.getImage();
  }

  Future<String?> getName() async {
    return await configRepository.getName();
  }

  Future<int?> updateImage({required String pathImage}) async {
    return await configRepository.updateImage(pathImage: pathImage);
  }

  Future<int?> updateName({required String name}) async {
    return await configRepository.updateName(name: name);
  }
}