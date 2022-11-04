import '../../domain/entities/config_app.dart';
class ConfigAppModel extends ConfigApp {
  ConfigAppModel({
    int? id,
    String? identificador,
    String? modulo,
    int? valor
  }) : super(id: id, identificador: identificador, modulo: modulo, valor: valor);
  
  factory ConfigAppModel.fromJson(Map json) {
    return ConfigAppModel(
      id: json["id"],
      identificador: json["identificador"],
      modulo: json["modulo"],
      valor: json["valor"]
    );
  }

  static ConfigApp fromModel(ConfigAppModel configAppModel) {
    return ConfigApp(
      id: configAppModel.id,
      identificador: configAppModel.identificador,
      modulo: configAppModel.modulo,
      valor: configAppModel.valor
    );
  }  
}