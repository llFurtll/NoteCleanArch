import 'package:note/domain/entities/config.dart';

class ConfigModel implements Config {
  @override
  String? nome;

  @override
  // ignore: non_constant_identifier_names
  String? path_foto;

  ConfigModel({
      this.nome,
      // ignore: non_constant_identifier_names
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