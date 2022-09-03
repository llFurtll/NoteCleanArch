import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/domain/interfaces/iscreen.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../../data/model/anotacao_model.dart';
import '../../../domain/usecases/crud_usecases.dart';
import '../../../presentation/pages/createpage/components/app_bar_create_component.dart';
import 'components/button_save_note_component.dart';
import '../../../../core/change_notifier_global.dart';

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
  final ChangeNotifierGlobal<String> _pathImageNotifier = ChangeNotifierGlobal("");
  final ChangeNotifierGlobal<Color> _colorNotifier = ChangeNotifierGlobal(Color(0xFF000000));
  final TextEditingController _title = TextEditingController();
  final FocusNode _focusTitle = FocusNode();
  final FocusNode _focusDesc = FocusNode();
  
  late AnotacaoModel? _anotacaoModel;
  late CrudUseCases useCases;
  late AppBarCreateComponent _appBarCreateComponent;
  late ButtonSaveNoteComponent _buttonSaveNoteComponent;

  QuillController _desc = QuillController.basic();

  @override
  void initState() {
    super.initState();

    useCases = injector.getDependencie();
    _appBarCreateComponent = AppBarCreateComponent(this);
    _buttonSaveNoteComponent = ButtonSaveNoteComponent(this);

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (widget.id != null) {
        _anotacaoModel = await useCases.getByIdUseCase(id: widget.id!);

        _title.text = _anotacaoModel!.titulo!;

        try {
          _desc = QuillController(
            document: Document.fromJson(jsonDecode(_anotacaoModel!.observacao!)),
            selection: TextSelection.collapsed(offset: 0)
          );
        } catch (e) {
           _desc.document.insert(0, _anotacaoModel!.observacao!);
        }

        if (_anotacaoModel!.imagemFundo != null && _anotacaoModel!.imagemFundo!.isNotEmpty) {
          _pathImageNotifier.value = _anotacaoModel!.imagemFundo!;
          _appBarCreateComponent.removeBackground = true;
        }

        if (_anotacaoModel!.cor != null && _anotacaoModel!.cor!.isNotEmpty) {
          _colorNotifier.value = Color(int.parse("${_anotacaoModel!.cor}"));
        }

        _appBarCreateComponent.showShare = true;
      }
    });
  }

  @override
  void dispose() {
    _appBarCreateComponent.dispose();
    super.dispose();
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
        appBar: _appBarCreateComponent.constructor(),
        body: _body(),
        floatingActionButton: _buttonSaveNoteComponent.constructor(),
      ),
    );
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
        errorStyle: TextStyle(color: _colorNotifier.value.withOpacity(0.5)),
        hintStyle: TextStyle(
          color: _colorNotifier.value.withOpacity(0.5),
          fontWeight: FontWeight.normal,
        ),
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: _colorNotifier.value,
        fontWeight: FontWeight.bold,
        fontSize: 25.0
      ),
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      focusNode: _focusTitle,
    );
  }

  QuillToolbar _options() {
    return QuillToolbar.basic(
      controller: _desc,
      toolbarIconSize: 20.0,
      locale: Locale('pt'),
      multiRowsDisplay: false,
      showCodeBlock: false,
      showInlineCode: false,
      showAlignmentButtons: true,
    );
  }

  QuillEditor _descricao() {
    return QuillEditor(
      controller: _desc,
      readOnly: false,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: FocusNode(),
      autoFocus: true,
      expands: true,
      padding: EdgeInsets.zero,
      minHeight: 250.0,
    );
  }

  Widget _home() {
    return ValueListenableBuilder(
      valueListenable: _colorNotifier,
      builder: (BuildContext context, Color value, Widget? widget) {
        return Container(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: [
              _options(),
              _titulo(),
              Form(
                key: _formKey,
                child: Expanded(
                  child: _descricao(),
                )
              ),
            ],
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

  ChangeNotifierGlobal<Color> get colorNotifier {
    return _colorNotifier;
  }

  String get titulo {
    return _title.text;
  }

  String get descricao {
    return jsonEncode(_desc.document.toDelta().toJson());
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

  TextEditingController get controllerTitle {
    return _title;
  }

  QuillController get controllerDesc {
    return _desc;
  }
}