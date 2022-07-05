import 'dart:io';

import 'package:flutter/material.dart';

import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/domain/interfaces/iscreen.dart';

import '../../../data/model/anotacao_model.dart';
import '../../../domain/usecases/crud_usecases.dart';
import '../../../presentation/pages/createpage/components/app_bar_create_component.dart';
import 'components/button_save_note_component.dart';

// ignore: must_be_immutable
class CreateNote extends StatefulWidget {
  int? id;

  CreateNote({this.id});

  @override
  CreateNoteState createState() => CreateNoteState();
}

class CreateNoteState extends State<CreateNote> implements IScreen {

  @override
  List<IComponent> listComponents = [];

  final CompManagerInjector injector = CompManagerInjector();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final ValueNotifier<String> _pathImageNotifier = ValueNotifier("");
  final ValueNotifier<Color> _colorNotifier = ValueNotifier(Color(0xFF000000));
  
  late AnotacaoModel? _anotacaoModel;
  late CrudUseCases useCases;
  late AppBarCreateComponent appBarCreateComponent;
  late ButtonSaveNoteComponent buttonSaveNoteComponent;

  TextEditingController _title = TextEditingController();
  TextEditingController _desc = TextEditingController();

  final FocusNode _focusTitle = FocusNode();
  final FocusNode _focusDesc = FocusNode();

  @override
  void initState() {
    super.initState();

    useCases = injector.getDependencie();
    appBarCreateComponent = AppBarCreateComponent(this);
    buttonSaveNoteComponent = ButtonSaveNoteComponent(this);

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (widget.id != null) {
        _anotacaoModel = await useCases.getByIdUseCase(id: widget.id!);

        _title.text = _anotacaoModel!.titulo!;
        _desc.text = _anotacaoModel!.observacao!;

        if (_anotacaoModel!.imagemFundo != null && _anotacaoModel!.imagemFundo!.isNotEmpty) {
          _pathImageNotifier.value = _anotacaoModel!.imagemFundo!;
          appBarCreateComponent.removeBackground = true;
        }

        if (_anotacaoModel!.cor != null && _anotacaoModel!.cor!.isNotEmpty) {
          _colorNotifier.value = Color(int.parse("${_anotacaoModel!.cor}"));
        }
      }
    });
  }

  TextFormField _titulo() {
    return TextFormField(
      controller: _title,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Por favor preencha o título!";
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: "Título",
        errorStyle: TextStyle(color: _colorNotifier.value),
        hintStyle: TextStyle(
          color: _colorNotifier.value,
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: _colorNotifier.value,
        fontWeight: FontWeight.bold,
        fontSize: 20.0
      ),
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      focusNode: _focusTitle,
    );
  }

  TextFormField _descricao() {
    return TextFormField(
      controller: _desc,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: _colorNotifier.value),
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: _colorNotifier.value,
        fontSize: 18.0
      ),
      minLines: 10,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      focusNode: _focusDesc,
    );
  }

  Widget _home() {
    return ValueListenableBuilder(
      valueListenable: _colorNotifier,
      builder: (BuildContext context, Color value, Widget? widget) {
        return Container(
          padding: EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _titulo(),
                  _descricao(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _body() {
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: _pathImageNotifier,
          builder: (BuildContext context, String value, Widget? widget) {
            return Container(
              decoration: _pathImageNotifier.value.isEmpty ? null : BoxDecoration(
                image: DecorationImage(
                  image: _pathImageNotifier.value.contains('lib') ?
                    AssetImage(_pathImageNotifier.value) as ImageProvider :
                    FileImage(File(_pathImageNotifier.value)),
                  fit: BoxFit.cover,
                ),
              ),
              width: double.infinity,
              height: double.infinity,
            );
          },
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white.withOpacity(0.5),
          child: SafeArea(
            child: _home(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _colorNotifier.value = Color(0xFF000000);
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: appBarCreateComponent.constructor(),
        body: _body(),
        floatingActionButton: buttonSaveNoteComponent.constructor(),
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
    if (message == "addComponent") {
      addComponent(value);
    }
  }

  String get pathImage {
    return _pathImageNotifier.value;
  }

  set pathImage(String path) {
    _pathImageNotifier.value = path;
  }
  
  Color get color {
    return _colorNotifier.value;
  }

  set color(Color color) {
    _colorNotifier.value = color;
  }

  ValueNotifier<Color> get colorNotifier {
    return _colorNotifier;
  }

  String get titulo {
    return _title.text;
  }

  String get descricao {
    return _desc.text;
  }

  GlobalKey<FormState> get formKey {
    return _formKey;
  }

  AnotacaoModel? get anotacao {
    return _anotacaoModel!;
  }

  set anotacao(AnotacaoModel? anotacao) {
    _anotacaoModel = anotacao;
  }

  int? get id {
    return widget.id;
  }

  set id(int? id) {
    widget.id = id;
  }

  FocusNode get focusTitle {
    return _focusTitle;
  }

  FocusNode get focusDesc {
    return _focusDesc;
  }
}