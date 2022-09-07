import 'package:flutter/material.dart';

import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/core/conversable.dart';

import '../../../components/show_message.dart';
import '../../../../data/model/anotacao_model.dart';
import '../create.dart';
import '../../../../domain/usecases/crud_usecases.dart';
import '../components/app_bar_create_component.dart';

class ButtonSaveNoteComponent implements IComponent<CreateNoteState, ValueListenableBuilder, void> {

  final CompManagerInjector _injector = CompManagerInjector();
  final CreateNoteState _screen;
  final Conversable _conversable = Conversable();

  late final CrudUseCases _useCases;
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
            backgroundColor: Theme.of(_screen.context).floatingActionButtonTheme.backgroundColor,
            onPressed: () => _screen.emitScreen(this),
            child: const Icon(Icons.save),
          )
        );
      }
    );
  }

  @override
  void event() {
    print(_screen.controllerDesc.document.toPlainText());
    if (_screen.controllerDesc.document.toPlainText().isNotEmpty) {
      if (_screen.id == null) {
        _insertNote();
      } else {
        _screen.anotacao!.observacao = _screen.descricao;
        _screen.anotacao!.imagemFundo = _screen.pathImage;
        _updateNote(_screen.anotacao!);
      }

      _conversable.callScreen("home")!.receive("refresh", "");
    } else {
      MessageDefaultSystem.showMessage(_screen.context, "Preencha a descrição!");
    }
  }

  @override
  void init() {
    _useCases = _injector.getDependencie();
    _appBarCreateComponent = _screen.getComponent(AppBarCreateComponent) as AppBarCreateComponent;
  }

  void dispose() {
    return;
  }

  void _insertNote() async {
    AnotacaoModel anotacaoModel = AnotacaoModel(
      observacao: _screen.descricao,
      data: DateTime.now().toIso8601String(),
      imagemFundo: _screen.pathImage,
      situacao: 1,
    );

    int? insert = await _useCases.insertUseCase(anotacao: anotacaoModel);

    if (insert != 0) {
      MessageDefaultSystem.showMessage(
        _screen.context,
        "Anotacão cadastrada com sucesso!"
      );

      _screen.id = insert!;

      _appBarCreateComponent.showShare = true;
      _appBarCreateComponent.changeMenuItens();

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