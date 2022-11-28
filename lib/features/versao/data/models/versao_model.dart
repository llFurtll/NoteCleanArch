import '../../domain/entities/versao.dart';

class VersaoModel extends Versao {
  const VersaoModel({
    required int? idVersao,
    required double? versao
  }) : super(
    idVersao: idVersao,
    versao: versao
  );

  factory VersaoModel.fromJson(Map json) {
    return VersaoModel(
      idVersao: json["id"],
      versao: json["versao"]
    );
  }
}