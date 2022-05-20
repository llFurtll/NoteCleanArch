import 'package:flutter/material.dart';

import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/core/compmanager_injector.dart';
import 'package:note/domain/usecases/crud_usecases.dart';

import '../../../../data/model/anotacao_model.dart';
import '../create.dart';

class ButtonSaveNoteComponent implements IComponent<CreateNoteState, FloatingActionButton, void> {

  final CompManagerInjector _injector = CompManagerInjector();
  final CreateNoteState _screen;

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
        _screen.anotacao!.cor = _screen.color.toString();
        _updateNote(_screen.anotacao!);
      }
    }
  }

  @override
  void init() {
    _useCases = _injector.getDependencie();
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
      ScaffoldMessenger.of(_screen.context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(_screen.context).primaryColor,
          content: Text("Anotacão cadastrada com sucesso!"),
          action: SnackBarAction(
            label: "Fechar",
            textColor: Colors.white,
            onPressed: () {},
          ),
        )
      );

      _screen.id = insert!;

      _screen.anotacao = await _useCases.getByIdUseCase(id: _screen.id!);
    }
  }

  void _updateNote(AnotacaoModel anotacao) async {
    int? updated = await _useCases.updateUseCase(anotacao: anotacao);

    if (updated != 0) {
      ScaffoldMessenger.of(_screen.context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(_screen.context).primaryColor,
          content: Text("Anotacão atualizada com sucesso!"),
          action: SnackBarAction(
            label: "Fechar",
            textColor: Colors.white,
            onPressed: () {},
          ),
        )
      );
    }
  }
}