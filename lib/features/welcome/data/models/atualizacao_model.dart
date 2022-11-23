import 'package:note/features/welcome/domain/entities/atualizacao.dart';

class AtualizacaoModel extends Atualizacao {
  const AtualizacaoModel({
    required int? id,
    required double? versao,
    required String? cabecalho,
    required String? descricao,
    required String? imagem
  }) : super(
    id: id,
    versao: versao,
    cabecalho: cabecalho,
    descricao: descricao,
    imagem: imagem
  );

  factory AtualizacaoModel.fromJson(Map json) {
    return AtualizacaoModel(
      id: json["id"],
      versao: json["versao"],
      cabecalho: json["cabecalho"],
      descricao: json["descricao"],
      imagem: json["imagem"]
    );
  }
}