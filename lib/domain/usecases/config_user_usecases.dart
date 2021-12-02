import 'package:note/data/repositories/config_repository.dart';

class ConfigUserUseCases {
  ConfigUserRepository configRepository;

  ConfigUserUseCases({required this.configRepository});

  Future<String?> getImage() async {
    return await configRepository.getImage();
  }

  Future<String?> getName() async {
    return await configRepository.getName();
  }

  Future<int?> updateImage({required String path_image}) async {
    return await configRepository.updateImage(path_image: path_image);
  }

  Future<int?> updateName({required String name}) async {
    return await configRepository.updateName(name: name);
  }
}