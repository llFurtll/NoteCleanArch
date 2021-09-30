import 'package:note/domain/entities/anotacao.dart';

class AnotacaoModel implements Anotacao {
  @override
  String? data;

  @override
  int? id;

  @override
  String? imagemFundo;

  @override
  String? observacao;

  @override
  int? situacao;

  @override
  String? titulo;


  AnotacaoModel({
    this.id,
    this.data,
    this.imagemFundo,
    this.observacao,
    this.situacao,
    this.titulo
  });

  @override
  factory AnotacaoModel.fromJson(Map json) {
    return AnotacaoModel(
      id: json["id"],
      data: json["data"],
      imagemFundo: json["imagem_fundo"],
      observacao: json["observacao"],
      situacao: json["situacao"],
      titulo: json["titulo"]
    );
  }
}