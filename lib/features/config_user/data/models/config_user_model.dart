import '../../domain/entities/config_user.dart';

class ConfigUserModel extends ConfigUser {
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

  static ConfigUser fromModel(ConfigUserModel configModel) {
    return ConfigUser(
      pathFoto: configModel.pathFoto,
      nome: configModel.nome
    );
  }
}