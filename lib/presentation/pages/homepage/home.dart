import 'package:compmanager/core/conversable.dart';
import 'package:flutter/material.dart';

import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/domain/interfaces/iscreen.dart';

import 'components/header_component.dart';
import 'components/list_component.dart';
import 'components/button_add_note_component.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> implements IScreen  {

  @override
  List<IComponent> listComponents = [];

  final CompManagerInjector injector = CompManagerInjector();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Conversable _conversable = Conversable();
  final ScrollController _customController = ScrollController();
  final ValueNotifier<bool> _showTitle = ValueNotifier(false);

  late final HeaderComponent _headerComponent;
  late final ListComponent _listComponent;
  late final ButtonAddNoteComponent _buttonAddNoteComponent;

  @override
  void initState() {
    super.initState();
    
    _headerComponent = HeaderComponent(this);
    _listComponent = ListComponent(this);
    _buttonAddNoteComponent = ButtonAddNoteComponent(this);
    
    addComponent(_headerComponent);
    addComponent(_listComponent);
    addComponent(_buttonAddNoteComponent);

    _conversable.addScren("home", this);
  }

  @override
  void dispose() {
    _customController.dispose();
    _headerComponent.dispose();

    super.dispose();
  }

  Widget _home() {
    return CustomScrollView(
      slivers: <Widget>[
        _headerComponent.constructor(),
        _listComponent.constructor()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () => _headerComponent.removeFocusNode(),
        child: _home(),
      ),
      floatingActionButton: _buttonAddNoteComponent.constructor(),
    );
  }

  @override
  void emitScreen(IComponent component) {
    component.event();
  }

  @override
  void receive(String message, value, {IScreen? screen}) {
    switch (message) {
      case 'refresh':
        _listComponent.getNotes("");
    }
  }

  @override
  void addComponent(IComponent component) {
    listComponents.add(component);
  }

  @override
  IComponent getComponent(Type type) {
    return listComponents.firstWhere((element) => element.runtimeType == type);
  }

  ValueNotifier<bool> get title {
    return _showTitle;
  }
}