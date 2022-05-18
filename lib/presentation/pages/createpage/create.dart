import 'dart:io';

import 'package:flutter/material.dart';

import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/domain/interfaces/iscreen.dart';

import '../../../data/model/anotacao_model.dart';
import '../../../domain/usecases/crud_usecases.dart';
import '../../../presentation/pages/createpage/components/app_bar_create_component.dart';
import '../../../core/config_app.dart';

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
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<String> _pathImageNotifier = ValueNotifier("");
  final ValueNotifier<Color> _colorNotifier = ValueNotifier(Color(0xFF000000));
  
  late AnotacaoModel? _anotacaoModel;
  late CrudUseCases useCases;
  late AppBarCreateComponent appBarCreateComponent;

  TextEditingController _title = TextEditingController();
  TextEditingController _obs = TextEditingController();
  TextEditingController _cor = TextEditingController();

  @override
  void initState() {
    super.initState();

    useCases = injector.getDependencie();
    appBarCreateComponent = AppBarCreateComponent(this);
    addComponent(appBarCreateComponent);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.id != null) {
        Future.sync(() async {

          _anotacaoModel = await useCases.getByIdUseCase(id: widget.id!);

          _title.text = _anotacaoModel!.titulo!;
          _obs.text = _anotacaoModel!.observacao!;

          setState(() {
            if (_anotacaoModel!.imagemFundo != null && _anotacaoModel!.imagemFundo!.isNotEmpty) {
              _pathImageNotifier.value = _anotacaoModel!.imagemFundo!;
              ConfigApp.of(context).removeBackground = true;
            }

            if (_anotacaoModel!.cor != null && _anotacaoModel!.cor!.isNotEmpty) {
              ConfigApp.of(context).color = Color(int.parse("0xFF${_anotacaoModel!.cor}"));
            }
          });
        });
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
    );
  }

  TextFormField _descricao() {
    return TextFormField(
      controller: _obs,
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

  FloatingActionButton _button() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (widget.id == null) {
            _insertNote();
          } else {
            _anotacaoModel!.titulo = _title.text;
            _anotacaoModel!.observacao = _obs.text;
            _anotacaoModel!.imagemFundo = _pathImageNotifier.value;
            _anotacaoModel!.cor = _cor.text.isNotEmpty ? _cor.text : _anotacaoModel!.cor;
            _updateNote(_anotacaoModel!);
          }
        }
      },
      child: const Icon(Icons.save),
    );
  }

  void _insertNote() async {
    AnotacaoModel anotacaoModel = AnotacaoModel(
      titulo: _title.text,
      observacao: _obs.text,
      data: DateTime.now().toIso8601String(),
      imagemFundo: _pathImageNotifier.value,
      situacao: 1,
      cor: _cor.text
    );

    int? insert = await useCases.insertUseCase(anotacao: anotacaoModel);

    if (insert != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text("Anotacão cadastrada com sucesso!"),
          action: SnackBarAction(
            label: "Fechar",
            textColor: Colors.white,
            onPressed: () {},
          ),
        )
      );
      setState(() {
        widget.id = insert;
      });
      _anotacaoModel = await useCases.getByIdUseCase(id: widget.id!);
    }
  }

  void _updateNote(AnotacaoModel anotacao) async {
    int? updated = await useCases.updateUseCase(anotacao: anotacao);

    if (updated != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
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
        floatingActionButton: _button(),
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

  ValueNotifier<Color> get colorNotifier {
    return _colorNotifier;
  }
}