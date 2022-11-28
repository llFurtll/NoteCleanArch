import '../../domain/entities/atualizacao.dart';

class AtualizacaoModel extends Atualizacao {
  const AtualizacaoModel({
    required int? id,
    required int? idVersao,
    required String? cabecalho,
    required String? descricao,
    required String? imagem
  }) : super(
    id: id,
    idVersao: idVersao,
    cabecalho: cabecalho,
    descricao: descricao,
    imagem: imagem
  );

  factory AtualizacaoModel.fromJson(Map json) {
    return AtualizacaoModel(
      id: json["id"],
      idVersao: json["id_versao"],
      cabecalho: json["cabecalho"],
      descricao: json["descricao"],
      imagem: json["imagem"]
    );
  }
}