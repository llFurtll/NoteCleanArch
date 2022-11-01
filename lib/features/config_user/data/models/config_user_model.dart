import '../../domain/entities/config.dart';

class ConfigUserModel extends Config {
  ConfigUserModel(
    {
      String? pathFoto,
      String? nome
    }
  ) : super(pathFoto: pathFoto, nome: nome);

  factory ConfigUserModel.fromJson(Map json) {
    return ConfigUserModel(
      pathFoto: json["path_foto"],
      nome: json["nome"]
    );
  }

  static Config fromModel(ConfigUserModel configModel) {
    return Config(
      pathFoto: configModel.pathFoto,
      nome: configModel.nome
    );
  }
}