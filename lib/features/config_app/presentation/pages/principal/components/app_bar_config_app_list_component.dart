import 'package:flutter/material.dart';

import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../config_app_list.dart';

class AppBarConfigAppListComponent implements IComponent<ConfigAppListState, PreferredSize, Future<bool>> {
  final ConfigAppListState _screen;

  final String _title = "Configurações";

  AppBarConfigAppListComponent(this._screen);

  @override
  Future<bool> afterEvent() async {
    return true;
  }

  @override
  Future<bool> beforeEvent() async {
    return true;
  }

  @override
  PreferredSize constructor() {
    return PreferredSize(
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(_screen.context).primaryColor,
        title: Text(_title),
        leading: _iconLeading(),
      ),
      preferredSize: Size.fromHeight(60.0),
    );
  }

  @override
  void dispose() {
    return;
  }

  @override
  Future<bool> event() async {
    return true;
  }

  @override
  void init() {
    return;
  }

  Widget _iconLeading() {
    return IconButton(
      tooltip: "Voltar",
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () => Navigator.of(_screen.context).pop(),
    );
  }
}