import 'package:note/domain/entities/config.dart';

class ConfigModel implements Config {
  @override
  String? nome;

  @override
  String? path_foto;

  ConfigModel({
      this.nome,
      this.path_foto
    }
  );

  @override
  factory ConfigModel.froJson(Map json) {
    return ConfigModel(
      nome: json["nome"],
      path_foto: json["path_foto"],
    );
  }
}