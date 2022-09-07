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

class CreateNoteState extends State<CreateNote> with WidgetsBindingObserver implements IScreen {

  @override
  List<IComponent> listComponents = [];

  final CompManagerInjector injector = CompManagerInjector();
  final ChangeNotifierGlobal<String> _pathImageNotifier = ChangeNotifierGlobal("");
  final ChangeNotifierGlobal<bool> _keyboardVisible = ChangeNotifierGlobal(false);
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

        _appBarCreateComponent.showShare = true;
      }
    });

    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    _appBarCreateComponent.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() async {
    _keyboardVisible.value = await _verifyKeyboard;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: _appBarCreateComponent.constructor(),
      body: _body(),
      floatingActionButton: _buttonSaveNoteComponent.constructor(),
    );
  }

  ValueListenableBuilder _options() {
    return ValueListenableBuilder<bool>(
      valueListenable: _keyboardVisible,
      builder: (BuildContext context, bool value, Widget? widget) {
        return Visibility(
          visible: _keyboardVisible.value,
          child: Positioned(
            child: QuillToolbar.basic(
              controller: _desc,
              toolbarIconSize: 20.0,
              locale: Locale('pt'),
              multiRowsDisplay: false,
              showCodeBlock: false,
              showInlineCode: false,
              showFontSize: false,
              showAlignmentButtons: true,            
            ),
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
        );
      }
    );
  }

  QuillEditor _descricao() {
    return QuillEditor(
      controller: _desc,
      readOnly: false,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: _focusDesc,
      autoFocus: false,
      expands: true,
      padding: EdgeInsets.zero,
      minHeight: 250.0
    );
  }

  Widget _home() {
    return Container(
      padding: EdgeInsets.all(20.0),
        child:  Column(
        children: [
          Expanded(
            child: _descricao(),
          )
        ],
      ),
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
        _options()
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

  Future<bool> get _verifyKeyboard async {
    final check = () => (WidgetsBinding.instance?.window.viewInsets.bottom ?? 0) > 0;
    if (!check()) return false;
    return await Future.delayed(Duration(milliseconds: 100), () => check());
  }

  ChangeNotifierGlobal<bool> get keyboardVisible {
    return _keyboardVisible;
  }

  String get pathImage {
    return _pathImageNotifier.value;
  }

  set pathImage(String path) {
    _pathImageNotifier.value = path;
  }

  String get descricao {
    return jsonEncode(_desc.document.toDelta().toJson());
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

  QuillController get controllerDesc {
    return _desc;
  }
}