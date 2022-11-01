import '../../domain/entities/home_anotacao.dart';

class HomeAnotacaoModel extends HomeAnotacao {
  HomeAnotacaoModel(
    {
      int? id,
      String? titulo,
      String? data,
      String? imagemFundo
    }
  ) : super(id: id, titulo: titulo, data: data, imagemFundo: imagemFundo);

  factory HomeAnotacaoModel.fromJson(Map json) {
    return HomeAnotacaoModel(
      id: json["id"],
      titulo: json["titulo"],
      data: json["data"],
      imagemFundo: json["imagem_fundo"]
    );
  }
  
  static HomeAnotacao fromModel(HomeAnotacaoModel anotacaoModel) {
    return HomeAnotacao(
      id: anotacaoModel.id,
      titulo: anotacaoModel.titulo,
      data: anotacaoModel.data,
      imagemFundo: anotacaoModel.imagemFundo
    );
  }
}