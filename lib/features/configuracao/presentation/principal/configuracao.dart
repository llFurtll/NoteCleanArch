import 'package:flutter/material.dart';

import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/domain/interfaces/iscreen.dart';

import 'components/app_bar_configuracao_component.dart';

class Configuracao extends StatefulWidget {
  static String routeConfiguracao = "/configuracao";

  @override
  ConfiguracaoState createState() => ConfiguracaoState();
}

class ConfiguracaoState extends State<Configuracao> implements IScreen {
  late final AppBarConfiguracaoComponent _appBarConfiguracaoComponent;

  @override
  List<IComponent> listComponents = [];

  @override
  void initState() {
    super.initState();
    _appBarConfiguracaoComponent = AppBarConfiguracaoComponent(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarConfiguracaoComponent.constructor(),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfo(),
            _buildDivider(),
            _buildSecao([
              _itemSecao("Configurações de anotações", Icon(Icons.note)),
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
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...widgets.map((element) => element)
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemSecao(String title, Icon icon) {
    return Row(
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
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.black
    );
  }
}