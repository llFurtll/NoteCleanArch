
import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/dependencies/repository_injection.dart';
import '../../../../../../core/widgets/show_loading.dart';
import '../../../../../../core/widgets/show_message.dart';
import '../../../../domain/entities/config_app.dart';
import '../../../../domain/usecases/config_app_use_case.dart';
import '../config_app_edit.dart';
import 'list_config_app_edit_component.dart';

class AppBarConfigAppEditComponent implements IComponent<ConfigAppEditState, PreferredSize, void> {
  final ConfigAppEditState _screen;

  late final String _modulo;
  late final ListConfigAppEditComponent _listConfigAppEditComponent;
  
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
  void bindings() {}

  @override
  Future<void> loadDependencies() async {}

  @override
  PreferredSize constructor() {
    switch (_modulo) {
      case "NOTE":
        _title = "Configurações de anotação";
        break;
      case "APP":
        _title = "Configurações do aplicativo";
        break;
      default:
        _title = "Configuração não encontrada";
    }

    return PreferredSize(
      child: AppBar(
        backgroundColor: Theme.of(_screen.context).primaryColor,
        title: Text(_title, style: TextStyle(fontSize: 16.0)),
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
        bool houveErro = false;
        final configAppUseCase = ConfigAppUseCase(repository: RepositoryInjection.of(_screen.context)!.configAppRepository);

        showLoading(_screen.context);

        for (var item in _listConfigAppEditComponent.listaConfigs) {
          ConfigApp configApp = ConfigApp(
            id: null,
            identificador: item.identificador,
            modulo: _modulo,
            valor: item.valor
          );
          
          int? update = await configAppUseCase.updateConfig(config: configApp);

          if (update == null || update == 0) {
            houveErro = true;
            break;
          }
        }

        Navigator.of(_screen.context).pop();

        if (houveErro) {
          showMessage(_screen.context, "Erro ao salvar as configurações, tente novamente!");
        } else {
          showMessage(_screen.context, "Configurações atualizadas com sucesso!");
        }
      },
      child: Text("Salvar"),
      style: TextButton.styleFrom(
        primary: Colors.white
      ),
    );
  }
}