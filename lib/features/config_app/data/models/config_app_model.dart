import '../../domain/entities/config_app.dart';

class ConfigAppModel implements ConfigApp {
  @override
  int? id;

  @override
  String? identificador;

  @override
  String? modulo;

  @override
  int? valor;

  ConfigAppModel({
    this.id,
    this.identificador,
    this.modulo,
    this.valor
  });
  
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