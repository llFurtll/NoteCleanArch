import '../../domain/entities/config.dart';

class ConfigModel implements Config {
  @override
  String? nome;

  @override
  String? pathFoto;

  ConfigModel({
      this.nome,
      this.pathFoto
    }
  );

  @override
  factory ConfigModel.froJson(Map json) {
    return ConfigModel(
      nome: json["nome"],
      pathFoto: json["path_foto"],
    );
  }
}