import '../../features/note/data/model/anotacao_model.dart';
import '../../features/note/domain/entities/anotacao.dart';

Anotacao gerarAnotacao(
  {int id = 0, String data = "",
  int situacao = 1, String imagemFundo = "", String observacao = "", String titulo = ""}
  ) {
    AnotacaoModel anotacao =  new AnotacaoModel(
      id: id,
      data: data,
      situacao: situacao,
      imagemFundo: imagemFundo,
      observacao: observacao,
      titulo: titulo
    );

    return anotacao;
}

Map<String, Object?> inserirAnotacao() {
  Map<String, Object?> insert = Map();

  insert["data"] = DateTime.now().toIso8601String();
  insert["situacao"] = 1;
  insert["imagem_fundo"] = "http";
  insert["observacao"] = "teste";
  insert["titulo"] = "teste desc";

  return insert;
}

Map<String, Object?> updateConfigUser() {
  Map<String, Object?> update = Map();

  update["path_foto"] = "https://teste.com.br/teste.jpg";
  update["nome"] = "Daniel Melonari";

  return update;
}