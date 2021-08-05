import 'package:note/domain/entities/anotacao.dart';

class AnotacaoModel extends Anotacao {
  AnotacaoModel({
    titulo, data, situacao, imagemFundo, observacao
  }) : super(
    titulo: "",
    data: DateTime.now().toIso8601String(),
    situacao: 1,
    imagemFundo: "",
    observacao: ""
  );
}