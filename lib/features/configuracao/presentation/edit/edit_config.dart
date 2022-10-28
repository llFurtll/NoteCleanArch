import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/domain/interfaces/iscreen.dart';
import 'package:flutter/material.dart';

class EditConfig extends StatefulWidget {
  static String routeEditConfig = "/configuracao/edit";

  @override
  EditConfigState createState() => EditConfigState();
}

class EditConfigState extends State<EditConfig> implements IScreen {

  @override
  List<IComponent<IScreen, dynamic, dynamic>> listComponents = [];
 
  @override
  Widget build(BuildContext context) {
    return Scaffold();
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