abstract class Anotacao {
  int? id;
  @deprecated
  String? titulo;
  String? data;
  int? situacao;
  String? imagemFundo;
  String? observacao;
  @deprecated
  String? cor;
  
  Anotacao();

  Anotacao.fromJson(Map json);
}