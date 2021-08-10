import 'package:note/data/model/anotacao_model.dart';
import 'package:note/domain/entities/anotacao.dart';

Anotacao gerarAnotacao(
  {int id = 0, String titulo = "", String data = "",
  int situacao = 1, String imagemFundo = "", String observacao = ""}
  ) {
    AnotacaoModel anotacao =  new AnotacaoModel(
      id: id,
      titulo: titulo,
      data: data,
      situacao: situacao,
      imagemFundo: imagemFundo,
      observacao: observacao
    );

    return anotacao;
}

Map<String, Object?> inserirAnotacao() {
  Map<String, Object?> insert = Map();

  insert["titulo"] = "teste";
  insert["data"] = DateTime.now().toIso8601String();
  insert["situacao"] = 1;
  insert["imagem_fundo"] = "http";
  insert["observacao"] = "gostei";

  return insert;
}