import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/domain/interfaces/iscreen.dart';
import 'package:flutter/material.dart';

import 'components/app_bar_config_app_edit_component.dart';
import 'components/list_config_app_edit_component.dart';

class ConfigAppEdit extends StatefulWidget {
  static String routeConfigAppEdit = "/cofig/app/edit";

  @override
  ConfigAppEditState createState() => ConfigAppEditState();
}

class ConfigAppEditState extends State<ConfigAppEdit> implements IScreen {
  @override
  List<IComponent<IScreen, dynamic, dynamic>> listComponents = [];

  late final AppBarConfigAppEditComponent _appBarConfigAppEditComponent;
  late final ListConfigAppEditComponent _listConfigAppEditComponent;

  @override
  void initState() {
    super.initState();
    _appBarConfigAppEditComponent = AppBarConfigAppEditComponent(this);
    _listConfigAppEditComponent = ListConfigAppEditComponent(this);
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarConfigAppEditComponent.constructor(),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: _listConfigAppEditComponent.constructor(),
      ),
    );
  }

  @override
  void addComponent(IComponent component) {
    listComponents.add(component);
  }

  @override
  void emitScreen(IComponent component) {
    component.event();
  }

  @override
  IComponent getComponent(Type type) {
    return listComponents.firstWhere((element) => element.runtimeType == type);
  }

  @override
  void receive(String message, value, {IScreen? screen}) {
    return;
  }

}