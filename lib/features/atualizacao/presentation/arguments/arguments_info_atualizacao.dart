import '../../domain/entities/atualizacao.dart';

class ArgumentsInfoAtualizacao {
  final bool start;
  final List<Atualizacao> list;

  const ArgumentsInfoAtualizacao({
    required this.start,
    required this.list
  });
}