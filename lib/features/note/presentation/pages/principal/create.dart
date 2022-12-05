import 'dart:io';

import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/domain/interfaces/iscreen.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/adapters/implementatios/editor_note.dart';
import '../../../../../../core/notifiers/change_notifier_global.dart';
import '../../../../../../core/utils/format_date.dart';
import '../../../../../core/dependencies/repository_injection.dart';
import '../../../../config_app/domain/usecases/config_app_use_case.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/usecases/note_usecase.dart';
import 'components/app_bar_create_component.dart';
import 'components/button_save_note_component.dart';

// ignore: must_be_immutable
class CreateNote extends StatefulWidget {
  static String routeCreate = "/create";

  int? id;

  CreateNote({this.id});

  @override
  CreateNoteState createState() => CreateNoteState();
}

class CreateNoteState extends State<CreateNote> with WidgetsBindingObserver implements IScreen {

  @override
  List<IComponent> listComponents = [];

  final ChangeNotifierGlobal<String> _pathImageNotifier = ChangeNotifierGlobal("");
  final ChangeNotifierGlobal<bool> _keyboardVisible = ChangeNotifierGlobal(false);
  final ChangeNotifierGlobal<bool> _carregandoDependencias = ChangeNotifierGlobal(true);
  final ChangeNotifierGlobal<bool> _showButtonSave = ChangeNotifierGlobal(true);
  final FocusNode _focusTitle = FocusNode();
  final TextEditingController _title = TextEditingController();

  late final AppBarCreateComponent _appBarCreateComponent;
  late final HtmlEditorNote _editor;
  late final ButtonSaveNoteComponent _buttonSaveNoteComponent;
  late final ConfigAppUseCase _configAppUseCase;
  late final Map<String?, int?> _configsApp;

  late Note _note;

  @override
  void initState() {
    super.initState();

    _appBarCreateComponent = AppBarCreateComponent(this);
    _editor = HtmlEditorNote(this);
    _buttonSaveNoteComponent = ButtonSaveNoteComponent(this);

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (widget.id != null) {
        final noteUseCase = NoteUseCase(repository: RepositoryInjection.of(context)!.noteRepository);
        _note = await noteUseCase.getByIdUseCase(id: widget.id!);
        _title.text = _note.titulo!;

        if (_note.imagemFundo != null && _note.imagemFundo!.isNotEmpty) {
          _pathImageNotifier.value = _note.imagemFundo!;
          _appBarCreateComponent.removeBackground = true;
        }
        _appBarCreateComponent.showShare = true;
        if (note.ultimaAtualizacao != null) {
          _appBarCreateComponent.changeTitle("Salvo em: ${formatDate(note.ultimaAtualizacao!, false, true)}"); 
        }
      }

      _appBarCreateComponent.bindings();
      _editor.bindinds();
      _buttonSaveNoteComponent.bindings();
      _configAppUseCase = ConfigAppUseCase(repository: RepositoryInjection.of(context)!.configAppRepository);
      await dependencies();
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: _appBarCreateComponent.constructor(),
      body: ValueListenableBuilder(
        valueListenable: _carregandoDependencias,
        builder: (BuildContext context, bool value, Widget? widget) {
          if (value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return _body();
          }
        },
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _showButtonSave,
        builder: (BuildContext context, bool value, Widget? widget) {
          if (value) {
            return _buttonSaveNoteComponent.constructor();
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  TextFormField _titulo() {
    return TextFormField(
      onChanged: _configsApp["AUTOSAVE"] == 1 ? (String? value) => _appBarCreateComponent.emitComponentAutoSave() : null,
      controller: _title,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Por favor preencha o título!";
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: "Título",
        errorStyle: TextStyle(color: Colors.red),
        hintStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 25.0
      ),
      minLines: 1,
      maxLines: 2,
      keyboardType: TextInputType.multiline,
      focusNode: _focusTitle,
      onTap: () {
        if (_keyboardVisible.value) {
          _keyboardVisible.value = false;
        }
      },
    );
  }

  Widget _descricao() {
    return _editor.constructor();
  }

  Widget _home() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _titulo(),
          _editor.options(),
          Expanded(
            child: _descricao(),
          ),
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
         _editor.optionsKeyboard()
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

  @override
  Future<void> dependencies() async {
    _configsApp = await _configAppUseCase.getAllConfigs(modulo: "APP");
    _showButtonSave.value = _configsApp["AUTOSAVE"] == 0;
    await _editor.loadDependencies();
    await _appBarCreateComponent.loadDependencies();

    _carregandoDependencias.value = false;
  }

  Future<bool> get _verifyKeyboard async {
    final check = () => (WidgetsBinding.instance?.window.viewInsets.bottom ?? 0) > 0 && !_focusTitle.hasFocus;
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

  Note get note {
    return _note;
  }

  set anotacao(Note note) {
    _note = note;
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

  HtmlEditorNote get editor {
    return _editor;
  }

  TextEditingController get title {
    return _title;
  }

  void emitComponentAutoSave() {
    _appBarCreateComponent.emitComponentAutoSave();
  }
}