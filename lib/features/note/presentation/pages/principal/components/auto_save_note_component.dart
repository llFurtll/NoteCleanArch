import 'dart:async';

import 'package:compmanager/core/conversable.dart';
import 'package:flutter/material.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../../../../../../core/notifiers/change_notifier_global.dart';
import '../../../../../../core/dependencies/repository_injection.dart';
import '../../../../../../core/utils/format_date.dart';
import '../../../../domain/usecases/note_usecase.dart';
import '../../../../domain/entities/note.dart';
import '../create.dart';
import 'app_bar_create_component.dart';

class AutoSaveNoteComponent implements IComponent<CreateNoteState, ValueListenableBuilder, Future<int>> {
  final CreateNoteState _screen;
  final ChangeNotifierGlobal<String> _info = ChangeNotifierGlobal("");
  final Conversable _conversable = Conversable();

  late final AppBarCreateComponent _appBarCreateComponent;

  String tmpTitle = "";
  String tmpContent = "";

  bool _estaSalvando = false;
  Timer? _debounce;

  AutoSaveNoteComponent(this._screen) {
    init();
  }

  @override
  Future<int> afterEvent() async {
    return 0;
  }

  @override
  Future<int> beforeEvent() async {
    return 0;
  }

  @override
  ValueListenableBuilder constructor() {
    final style = TextStyle(
      color: Colors.grey,
      fontSize: 12.0,
      fontWeight: FontWeight.bold
    );

    return ValueListenableBuilder<String>(
      valueListenable: _info,
      builder: (BuildContext context, String value, Widget? widget) {
        if (_estaSalvando) {
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10.0,
            children: [
              SizedBox(
                height: 10.0,
                width: 10.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              ),
              Text(value, style: style)
            ],
          );
        }

        return Text(value, style: style);
      },
    );
  }

  @override
  void dispose() {
    return;
  }

  @override
  Future<int> event() async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      _actionSave();
    });
    return 0;
  }

  @override
  void init() async {
    _screen.addComponent(this);
    _appBarCreateComponent = _screen.getComponent(AppBarCreateComponent) as AppBarCreateComponent;
  }

  void loadBindings() async {
    if (_screen.id != null) {
      tmpTitle = _screen.note.titulo!.trim();
      tmpContent = _screen.note.observacao!.trim();
    }
  }

  void _actionSave() async {
    String title = _screen.title.text.trim();
    String content = await _screen.editor.getText();

    if (title.isEmpty) {
      return;
    }

    if (tmpTitle == title && tmpContent == content) {
      return;
    } else {
      tmpTitle = title;
      tmpContent = content;
    }

    _estaSalvando = true;
    _info.value = "Salvando...";

    if (_screen.id == null) {
      _insertNote(title, content);
    } else {
      _screen.note.observacao = content;
      _screen.note.imagemFundo = _screen.pathImage;
      _screen.note.titulo = title;
      _updateNote(_screen.note);
    }

    _conversable.callScreen("home")!.receive("refresh", "");
  }

  void _insertNote(String title, String content) async {
    final noteUseCase = NoteUseCase(repository: RepositoryInjection.of(_screen.context)!.noteRepository);
    
    Note note = Note(
      observacao: content,
      titulo: title,
      data: DateTime.now().toIso8601String(),
      imagemFundo: _screen.pathImage,
      situacao: 1,
    );

    int? insert = await noteUseCase.insertUseCase(note: note);

    _estaSalvando = false;

    if (insert != null && insert > 0) {
       String now = DateTime.now().toIso8601String();
      _info.value = "Salvo em: ${formatDate(now, false, true)}";
      _screen.id = insert;
      _appBarCreateComponent.showShare = true;
      _appBarCreateComponent.changeMenuItens();
      _screen.anotacao = await noteUseCase.getByIdUseCase(id: _screen.id!);
    } else {
      _info.value = "Falha ao criar em:";
    }
  }

  void _updateNote(Note note) async {
    final noteUseCase = NoteUseCase(repository: RepositoryInjection.of(_screen.context)!.noteRepository);
    int? updated = await noteUseCase.updateUseCase(note: note);

    _estaSalvando = false;

    if (updated != null && updated > 0) {
      String now = DateTime.now().toIso8601String();
      _info.value = "Salvo em: ${formatDate(now, false, true)}";
    } else {
      _info.value = "Falha ao salvar:";
    }
  }
}