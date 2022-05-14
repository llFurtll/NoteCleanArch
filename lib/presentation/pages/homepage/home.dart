import 'package:flutter/material.dart';

import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/domain/interfaces/iscreen.dart';
import 'package:note/presentation/pages/homepage/components/button_add_note_component.dart';

import '../../../core/camera_gallery.dart';
import '../../../domain/usecases/config_user_usecases.dart';
import 'components/header_compornent.dart';
import 'components/list_component.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> implements IScreen  {

  @override
  List<IComponent> listComponents = [];

  final CompManagerInjector injector = CompManagerInjector();
  final ScrollController _customController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late final ConfigUserUseCases _configUserUseCases;
  late final HeaderComponent _headerComponent;
  late final ListComponent _listComponent;
  late final ButtonAddNoteComponent _buttonAddNoteComponent;

  @override
  void initState() {
    super.initState();

    _configUserUseCases = injector.getDependencie();
    _headerComponent = HeaderComponent(this);
    _listComponent = ListComponent();
    _buttonAddNoteComponent = ButtonAddNoteComponent(this);
    addComponent(_headerComponent);
    addComponent(_listComponent);
    addComponent(_buttonAddNoteComponent);
  
    // _customController.addListener(_collapsedOrScroll);
  }

  @override
  void dispose() {
    _customController.dispose();

    super.dispose();
  }

  void showOptionsPhoto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CameraGallery(
          useCase: _configUserUseCases,
          setState: () async {
            Navigator.of(context).pop();
            setState(() {});
          },
          removerImagem: false
        );
      }
    );
  }

  Widget _home() {
    return CustomScrollView(
      controller: _customController,
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
    return;
  }

  @override
  void addComponent(IComponent component) {
    listComponents.add(component);
  }

  @override
  IComponent getComponent(Type type) {
    return listComponents.firstWhere((element) => element.runtimeType == type);
  }
}