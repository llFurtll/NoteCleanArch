import 'package:note/domain/entities/anotacao.dart';

class AnotacaoModel extends Anotacao {
  AnotacaoModel() : super(
    titulo: "",
    data: DateTime.now(),
    situacao: false,
    imagemFundo: "",
    observacao: ""
  );
}