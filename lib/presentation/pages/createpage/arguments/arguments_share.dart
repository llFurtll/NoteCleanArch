import 'package:compmanager/domain/interfaces/iscreen.dart';

import '../../../../data/model/anotacao_model.dart';

class ArgumentsShare {
  final AnotacaoModel anotacaoModel;
  final IScreen screen;

  ArgumentsShare({
    required this.anotacaoModel,
    required this.screen
  });
}