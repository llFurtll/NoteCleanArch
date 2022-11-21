import 'package:flutter/material.dart';

import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/domain/interfaces/iscreen.dart';

import '../edit/config_app_edit.dart';
import 'components/app_bar_config_app_list_component.dart';

class ConfigAppList extends StatefulWidget {
  static String routeConfigAppList = "/conf/app/list";

  @override
  ConfigAppListState createState() => ConfigAppListState();
}

class ConfigAppListState extends State<ConfigAppList> implements IScreen {
  late final AppBarConfigAppListComponent _appBarConfigAppListComponent;

  @override
  List<IComponent> listComponents = [];

  @override
  void initState() {
    super.initState();
    _appBarConfigAppListComponent = AppBarConfigAppListComponent(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarConfigAppListComponent.constructor(),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfo(),
            _buildDivider(),
            _buildSecao([
              _itemSecao("Configurações do aplicativo", Icon(Icons.app_settings_alt), () {
                Navigator.of(context).pushNamed(ConfigAppEdit.routeConfigAppEdit, arguments: "APP");
              }),
              _buildDivider(),
              _itemSecao("Configurações de anotações", Icon(Icons.note), () {
                Navigator.of(context).pushNamed(ConfigAppEdit.routeConfigAppEdit, arguments: "NOTE");
              }),
            ])
          ],
        ),
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

  @override
  Future<void> dependencies() async {}

  Widget _buildInfo() {
    return Text(
      "Aqui nas configurações é possível realizar algumas customizações no Note.",
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold
      ),
    );
  }

  Widget _buildSecao(List<Widget> widgets) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 5.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ...widgets.map((element) => element)
        ],
      ),
    );
  }

  Widget _itemSecao(String title, Icon icon, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              spacing: 10.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                icon,
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
            Icon(Icons.arrow_forward_outlined)
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.black
    );
  }
}