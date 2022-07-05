import 'package:flutter/material.dart';

import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/core/conversable.dart';

import '../../../components/show_message.dart';
import '../../../../data/model/anotacao_model.dart';
import '../create.dart';
import '../../../../domain/usecases/crud_usecases.dart';

class ButtonSaveNoteComponent implements IComponent<CreateNoteState, FloatingActionButton, void> {

  final CompManagerInjector _injector = CompManagerInjector();
  final CreateNoteState _screen;
  final Conversable _conversable = Conversable();

  late final CrudUseCases _useCases;

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
  FloatingActionButton constructor() {
    return FloatingActionButton(
      backgroundColor: Theme.of(_screen.context).floatingActionButtonTheme.backgroundColor,
      onPressed: () => _screen.emitScreen(this),
      child: const Icon(Icons.save),
    );
  }

  @override
  void event() {
    if (_screen.formKey.currentState!.validate()) {
      if (_screen.id == null) {
        _insertNote();
      } else {
        _screen.anotacao!.titulo = _screen.titulo;
        _screen.anotacao!.observacao = _screen.descricao;
        _screen.anotacao!.imagemFundo = _screen.pathImage;
        _screen.anotacao!.cor = _screen.color.value.toString();
        _updateNote(_screen.anotacao!);
      }

      _conversable.callScreen("home")!.receive("refresh", "");
    }
  }

  @override
  void init() {
    _useCases = _injector.getDependencie();
  }

  void dispose() {
    return;
  }

  void _insertNote() async {
    AnotacaoModel anotacaoModel = AnotacaoModel(
      titulo: _screen.titulo,
      observacao: _screen.descricao,
      data: DateTime.now().toIso8601String(),
      imagemFundo: _screen.pathImage,
      situacao: 1,
      cor: _screen.color.value.toString()
    );

    int? insert = await _useCases.insertUseCase(anotacao: anotacaoModel);

    if (insert != 0) {
      MessageDefaultSystem.showMessage(
        _screen.context,
        "Anotacão cadastrada com sucesso!"
      );

      _screen.id = insert!;

      _screen.anotacao = await _useCases.getByIdUseCase(id: _screen.id!);
    }
  }

  void _updateNote(AnotacaoModel anotacao) async {
    int? updated = await _useCases.updateUseCase(anotacao: anotacao);

    if (updated != 0) {
      MessageDefaultSystem.showMessage(
        _screen.context,
        "Anotacão atualizada com sucesso!"
      );
    }
  }
}