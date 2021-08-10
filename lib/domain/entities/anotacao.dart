abstract class Anotacao {
  int? id;
  String? titulo;
  String? data;
  int? situacao;
  String? imagemFundo;
  String? observacao;
  
  Anotacao();

  Anotacao.fromJson(Map json);
}