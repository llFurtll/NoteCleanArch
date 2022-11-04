import 'package:compmanager/core/compmanager_injector.dart';
import 'package:flutter/material.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../../../../../../core/notifiers/change_notifier_global.dart';
import '../../../../domain/usecases/config_app_use_case.dart';
import '../config_app_edit.dart';

class ListConfigAppEditComponent implements IComponent<ConfigAppEditState, ValueListenableBuilder, void> {
  final ConfigAppEditState _screen;
  final CompManagerInjector _injector = CompManagerInjector();
  final ChangeNotifierGlobal<List<ItemConfigAppEdit>> _listaConfigsWidgets = ChangeNotifierGlobal([]);

  late final ConfigAppUseCase _configAppUseCase;
  late final String modulo;

  ListConfigAppEditComponent(this._screen) {
    init();
  }

  @override
  void afterEvent() {
    return;
  }

  @override
  void beforeEvent() {
    return;
  }

  @override
  ValueListenableBuilder constructor() {
    return ValueListenableBuilder<List<ItemConfigAppEdit>>(
      valueListenable: _listaConfigsWidgets,
      builder: (BuildContext context, List<ItemConfigAppEdit> value, Widget? widget) {
        if (value.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: value,
        );
      }
    );
  }

  @override
  void dispose() {
    return;
  }

  @override
  void event() {
    return;
  }

  @override
  void init() async {
    _screen.addComponent(this);
    _configAppUseCase = _injector.getDependencie();
    await _carregarConfigs();
  }

  Future<void> _carregarConfigs() async {
    modulo = _screen.widget.modulo!;
    Map<String?, int?> configs = await _configAppUseCase.getAllConfigs(modulo: modulo);
    for (var identificador in configs.keys) {
      _listaConfigsWidgets.value.add(ItemConfigAppEdit(identificador: identificador!, valor: configs[identificador]!));
    }

    _listaConfigsWidgets.emitChange();
  }

  List<ItemConfigAppEdit> get listaConfigs {
    return _listaConfigsWidgets.value;
  }
}

class ItemConfigAppEdit extends StatelessWidget {
  String identificador;
  int valor;

  ItemConfigAppEdit({required this.identificador, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5.0,
          children: [
            Text(
              _getDescription(identificador),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0
              ),
            ),
            Icon(_getIconConfig(identificador))
          ],
        ),
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Switch(
              value: valor == 1,
              onChanged: (bool value) => setState(() => value ? valor = 1 : valor = 0),
              activeColor: Theme.of(context).primaryColor,
            );
          }
        )
      ],
    );
  }

  String _getDescription(String identificador) {
    switch (identificador) {
      case "MOSTRAREVERTERPRODUZIRALTERACOES":
        return "Exibir botões de desfazer/refazer";
      case "MOSTRANEGRITO":
        return "Exibir botão de negrito?";
      case "MOSTRAITALICO":
        return "Exibir botão de itálico?";
      case "MOSTRASUBLINHADO":
        return "Exibir botão de sublinhado?";
      case "MOSTRASUBLINADOERISCADO":
        return "Exibir botão de sublinhado e riscado?";
      case "MOSTRAALINHAMENTOESQUERDA":
        return "Exibir botão alinhar à esquerda?";
      case "MOSTRAALINHAMENTOCENTRO":
        return "Exibir botão centralizar horizontalmente?";
      case "MOSTRAALINHAMENTODIREITA":
        return "Exibir botão alinhar à direita?";
      case "MOSTRAJUSTIFICADO":
        return "Exibir botão justificado?";
      case "MOSTRATABULACAODIREITA":
        return "Exibir botão aumentar recuo?";
      case "MOSTRATABULACAOESQUERDA":
        return "Exibir botão diminuir recuo?";
      case "MOSTRACORLETRA":
        return "Exibir botão cor da fonte?";
      case "MOSTRACORFUNDOLETRA":
        return "Exibir botão cor de realce?";
      case "MOSTRALISTAPONTO":
        return "Exibir botão de lista?";
      case "MOSTRALINHANUMERICA":
        return "Exibir botão de lista numérica?";
      case "MOSTRALINK":
        return "Exibir botão de link?";
      case "MOSTRAFOTO":
        return "Exibir botão de foto?";
      case "MOSTRAAUDIO":
        return "Exibir botão de audio?";
      case "MOSTRAVIDEO":
        return "Exibir botão de vídeo?";
      case "MOSTRATABELA":
        return "Exibir botão de tabela?";
      case "MOSTRASEPARADOR":
        return "Exibir botão de separador?";
    }

    return "";
  }

  IconData? _getIconConfig(String identificador) {
    switch (identificador) {
      case "MOSTRAREVERTERPRODUZIRALTERACOES":
        return null;
      case "MOSTRANEGRITO":
        return Icons.format_bold;
      case "MOSTRAITALICO":
        return Icons.format_italic;
      case "MOSTRASUBLINHADO":
        return Icons.format_underlined;
      case "MOSTRASUBLINADOERISCADO":
        return Icons.format_strikethrough;
      case "MOSTRAALINHAMENTOESQUERDA":
        return Icons.format_align_left;
      case "MOSTRAALINHAMENTOCENTRO":
        return Icons.format_align_center;
      case "MOSTRAALINHAMENTODIREITA":
        return Icons.format_align_right;
      case "MOSTRAJUSTIFICADO":
        return Icons.format_align_justify;
      case "MOSTRATABULACAODIREITA":
        return Icons.format_indent_increase_sharp;
      case "MOSTRATABULACAOESQUERDA":
        return Icons.format_indent_decrease;
      case "MOSTRACORLETRA":
        return Icons.format_color_text;
      case "MOSTRACORFUNDOLETRA":
        return Icons.format_color_fill;
      case "MOSTRALISTAPONTO":
        return Icons.list;
      case "MOSTRALINHANUMERICA":
        return Icons.format_list_numbered;
      case "MOSTRALINK":
        return Icons.link;
      case "MOSTRAFOTO":
        return Icons.image_outlined;
      case "MOSTRAAUDIO":
        return Icons.audiotrack_outlined;
      case "MOSTRAVIDEO":
        return Icons.videocam_outlined;
      case "MOSTRATABELA":
        return Icons.table_chart_outlined;
      case "MOSTRASEPARADOR":
        return Icons.horizontal_rule;
    }

    return null;
  }
}