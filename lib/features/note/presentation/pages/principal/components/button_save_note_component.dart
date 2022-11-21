import 'package:flutter/material.dart';

import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/core/conversable.dart';

import '../../../../../../../core/widgets/show_message.dart';
import '../../../../../../core/dependencies/repository_injection.dart';
import '../../../../../../core/utils/format_date.dart';
import '../../../../domain/entities/note.dart';
import '../../../../domain/usecases/note_usecase.dart';
import '../create.dart';
import 'app_bar_create_component.dart';

class ButtonSaveNoteComponent implements IComponent<CreateNoteState, ValueListenableBuilder, void> {
  final CreateNoteState _screen;
  final Conversable _conversable = Conversable();

  late final AppBarCreateComponent _appBarCreateComponent;
  late final NoteUseCase _noteUseCase;

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
  void bindings() {
    _noteUseCase = NoteUseCase(repository: RepositoryInjection.of(_screen.context)!.noteRepository);
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
      _appBarCreateComponent.changeEstaSalvando(true);
      _appBarCreateComponent.changeTitle("Salvando...");
      if (_screen.id == null) {
        _insertNote(title, content);
      } else {
        _screen.note.observacao = content;
        _screen.note.imagemFundo = _screen.pathImage;
        _screen.note.titulo = title;
        _screen.note.ultimaAtualizacao = DateTime.now().toIso8601String();
        _updateNote(_screen.note);
      }

      _conversable.callScreen("home")!.receive("refresh", "");
    } else {
      showMessage(_screen.context, "Título não pode estar vazio!");
    }
  }

  @override
  void init() {
    _appBarCreateComponent = _screen.getComponent(AppBarCreateComponent) as AppBarCreateComponent;
  }

  @override
  void dispose() {
    return;
  }

  @override
  Future<void> loadDependencies() async {}

  void _insertNote(String title, String content) async {
    Note note = Note(
      observacao: content,
      titulo: title,
      data: DateTime.now().toIso8601String(),
      imagemFundo: _screen.pathImage,
      situacao: 1,
      ultimaAtualizacao: DateTime.now().toIso8601String()
    );

    int? insert = await _noteUseCase.insertUseCase(note: note);

    _appBarCreateComponent.changeEstaSalvando(false);

    if (insert != 0) {
      showMessage(_screen.context, "Anotacão cadastrada com sucesso!");

      _screen.id = insert!;

      _appBarCreateComponent.showShare = true;
      _appBarCreateComponent.changeMenuItens();
      _appBarCreateComponent.changeTitle("Salvo em: ${formatDate(note.ultimaAtualizacao!, false, true)}");
      _screen.anotacao = await _noteUseCase.getByIdUseCase(id: _screen.id!);
    } else {
      showMessage(_screen.context, "Erro ao cadastrar a anotação, tente novamente!");
      _appBarCreateComponent.changeEstaSalvando(false);
      _appBarCreateComponent.changeTitle("");
    }
  }

  void _updateNote(Note note) async {
    int? updated = await _noteUseCase.updateUseCase(note: note);

    _appBarCreateComponent.changeEstaSalvando(false);

    if (updated != 0) {
      showMessage(_screen.context,"Anotacão atualizada com sucesso!");
      _appBarCreateComponent.changeTitle("Salvo em: ${formatDate(note.ultimaAtualizacao!, false, true)}");
    } else {
      showMessage(_screen.context, "Erro ao atualizar a anotação, tente novamente!");
      _appBarCreateComponent.changeEstaSalvando(false);
      _appBarCreateComponent.changeTitle("");
    }
  }
}