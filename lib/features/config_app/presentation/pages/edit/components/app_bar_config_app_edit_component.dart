import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:flutter/material.dart';

import '../../../../domain/usecases/config_app_use_case.dart';
import '../../../../domain/entities/config_app.dart';
import '../config_app_edit.dart';
import 'list_config_app_edit_component.dart';

class AppBarConfigAppEditComponent implements IComponent<ConfigAppEditState, PreferredSize, void> {
  final ConfigAppEditState _screen;
  final CompManagerInjector _injector = new CompManagerInjector();

  late final String _modulo;
  late final ListConfigAppEditComponent _listConfigAppEditComponent;
  late final ConfigAppUseCase _configAppUseCase;
  
  String _title = "";

  AppBarConfigAppEditComponent(this._screen) {
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
  PreferredSize constructor() {
    switch (_modulo) {
      case "NOTE":
        _title = "Configurações de anotação";
        break;
      default:
        _title = "Configuração não encontrada";
    }

    return PreferredSize(
      child: AppBar(
        backgroundColor: Theme.of(_screen.context).primaryColor,
        title: Text(_title),
        leading: _iconLeading(),
        actions: [
          _actionSave(),
        ],
      ),
      preferredSize: Size.fromHeight(56.0)
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
  void init() {
    _modulo = _screen.widget.modulo!;
    _listConfigAppEditComponent = _screen.getComponent(ListConfigAppEditComponent) as ListConfigAppEditComponent;
    _configAppUseCase = _injector.getDependencie();
  }
  
  Widget _iconLeading() {
    return IconButton(
      onPressed: () => Navigator.of(_screen.context).pop(),
      icon: Icon(Icons.arrow_back_ios)
    );
  }

  Widget _actionSave() {
    return TextButton(
      onPressed: () async {
        for (var item in _listConfigAppEditComponent.listaConfigs) {
          ConfigApp configApp = ConfigApp(
            id: null,
            identificador: item.identificador,
            modulo: _modulo,
            valor: item.valor
          );
          int? update = await _configAppUseCase.updateConfig(config: configApp);
        }
      },
      child: Text("Salvar"),
      style: TextButton.styleFrom(
        primary: Colors.white
      ),
    );
  }
}