import 'package:note/domain/entities/anotacao.dart';

class AnotacaoModel extends Anotacao {
  AnotacaoModel({
    id, titulo, data, situacao, imagemFundo, observacao
  }) : super(
    id: 0,
    titulo: "",
    data: DateTime.now(),
    situacao: false,
    imagemFundo: "",
    observacao: ""
  );
}