import '../../domain/entities/config_app.dart';
class ConfigAppModel extends ConfigApp {
  ConfigAppModel({
    int? id,
    String? identificador,
    String? modulo,
    int? valor
  }) : super(id: id, identificador: identificador, modulo: modulo, valor: valor);
  
  @override
  factory ConfigAppModel.fromJson(Map json) {
    return ConfigAppModel(
      id: json["id"],
      identificador: json["identificador"],
      modulo: json["modulo"],
      valor: json["valor"]
    );
  }
}