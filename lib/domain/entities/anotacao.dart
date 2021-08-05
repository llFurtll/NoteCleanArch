class Anotacao {
  int? id;
  String titulo;
  String data;
  int situacao;
  String imagemFundo;
  String observacao;

  Anotacao({
    this.id,
    required this.titulo,
    required this.data,
    required this.situacao,
    required this.imagemFundo,
    required this.observacao,
  });

  factory Anotacao.fromJson(Map json) {
    return Anotacao(
      id: json["id"],
      titulo: json["titulo"],
      data: json["data"], 
      situacao: json["situacao"],
      imagemFundo: json["imagem_fundo"],
      observacao: json["observacao"]
    );
  }
}