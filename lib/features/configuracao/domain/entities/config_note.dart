abstract class ConfigNote {
  int? id;
  String? identificador;
  int? valor;
  String? modulo;

  ConfigNote();

  ConfigNote.fromJson(Map json);
}