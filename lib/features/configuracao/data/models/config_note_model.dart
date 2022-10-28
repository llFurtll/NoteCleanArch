import '../../domain/entities/config_note.dart';

class ConfigNoteModel implements ConfigNote {
  @override
  int? id;

  @override
  String? identificador;

  @override
  String? modulo;

  @override
  int? valor;

  ConfigNoteModel({
    this.id,
    this.identificador,
    this.modulo,
    this.valor
  });
  
  @override
  factory ConfigNoteModel.fromJson(Map json) {
    return ConfigNoteModel(
      id: json["id"],
      identificador: json["identificador"],
      modulo: json["modulo"],
      valor: json["valor"]
    );
  }
}