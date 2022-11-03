import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:flutter/material.dart';

import '../config_app_edit.dart';

class AppBarConfigAppEditComponent implements IComponent<ConfigAppEditState, PreferredSize, void> {
  final ConfigAppEditState _screen;
  final String modulo;
  
  String _title = "";

  AppBarConfigAppEditComponent(this._screen, {required this.modulo});

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
    switch (modulo) {
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
    return;
  }
  
  Widget _iconLeading() {
    return IconButton(
      onPressed: () => Navigator.of(_screen.context).pop(),
      icon: Icon(Icons.arrow_back_ios)
    );
  }
}