import 'package:flutter/material.dart';

import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/core/conversable.dart';

import '../../../../../../../core/widgets/show_message.dart';
import '../../../../domain/entities/note.dart';
import '../../../../domain/usecases/note_usecase.dart';
import '../create.dart';
import 'app_bar_create_component.dart';

class ButtonSaveNoteComponent implements IComponent<CreateNoteState, ValueListenableBuilder, void> {

  final CompManagerInjector _injector = CompManagerInjector();
  final CreateNoteState _screen;
  final Conversable _conversable = Conversable();

  late final NoteUseCase _noteUseCase;
  late final AppBarCreateComponent _appBarCreateComponent;

  ButtonSaveNoteComponent(this._screen) {
    init();
  }

  @override
  void afterEvent() {
    return;
  }

  @override
  void beforeEvent() {
    return;
  }

  @override
  ValueListenableBuilder constructor() {
    return ValueListenableBuilder<bool>(
      valueListenable: _screen.keyboardVisible,
      builder: (BuildContext context, bool value, Widget? widget) {
        return Visibility(
          visible: !_screen.keyboardVisible.value,
          child: FloatingActionButton(
            tooltip: "Salvar",
            backgroundColor: Theme.of(_screen.context).floatingActionButtonTheme.backgroundColor,
            onPressed: () => _screen.emitScreen(this),
            child: const Icon(Icons.save),
          )
        );
      }
    );
  }

  @override
  void event() async {
    String title = _screen.title.text.trim();
    String content = await _screen.editor.getText();
    if (title.isNotEmpty) {
      if (_screen.id == null) {
        _insertNote(title, content);
      } else {
        _screen.note.observacao = content;
        _screen.note.imagemFundo = _screen.pathImage;
        _screen.note.titulo = title;
        _updateNote(_screen.note);
      }

      _conversable.callScreen("home")!.receive("refresh", "");
    } else {
      showMessage(_screen.context, "Título não pode estar vazio!");
    }
  }

  @override
  void init() {
    _noteUseCase = _injector.getDependencie();
    _appBarCreateComponent = _screen.getComponent(AppBarCreateComponent) as AppBarCreateComponent;
  }

  void dispose() {
    return;
  }

  void _insertNote(String title, String content) async {
    Note note = Note(
      observacao: content,
      titulo: title,
      data: DateTime.now().toIso8601String(),
      imagemFundo: _screen.pathImage,
      situacao: 1,
    );

    int? insert = await _noteUseCase.insertUseCase(note: note);

    if (insert != 0) {
      showMessage(_screen.context, "Anotacão cadastrada com sucesso!");

      _screen.id = insert!;

      _appBarCreateComponent.showShare = true;
      _appBarCreateComponent.changeMenuItens();

      _screen.anotacao = await _noteUseCase.getByIdUseCase(id: _screen.id!);
    } else {
      showMessage(_screen.context, "Erro ao cadastrar a anotação, tente novamente!");
    }
  }

  void _updateNote(Note note) async {
    int? updated = await _noteUseCase.updateUseCase(note: note);

    if (updated != 0) {
      showMessage(_screen.context,"Anotacão atualizada com sucesso!");
    } else {
      showMessage(_screen.context, "Erro ao atualizar a anotação, tente novamente!");
    }
  }
}