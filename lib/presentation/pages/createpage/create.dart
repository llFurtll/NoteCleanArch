import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/data/repositories/crud_repository.dart';
import 'package:note/domain/usecases/crud_usecases.dart';
import 'package:note/presentation/pages/createpage/appbar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:note/presentation/pages/createpage/config_app.dart';

class CreateNote extends StatefulWidget {
  final Function setState;
  final int? id;

  CreateNote({required this.setState, this.id});

  @override
  CreateNoteState createState() => CreateNoteState();
}

class CreateNoteState extends State<CreateNote> {

  final _formKey = GlobalKey<FormState>();
  late AnotacaoModel? _anotacaoModel;

  late CrudUseCases useCases;

  TextEditingController _title = TextEditingController();
  TextEditingController _obs = TextEditingController();
  TextEditingController _cor = TextEditingController();
  String _pathImage = "";

  @override
  void didChangeDependencies() {
    useCases = CrudUseCases(
      repository: CrudRepository(datasourceBase: ConfigApp.of(context).datasourceBase)
    );

    if (widget.id != null) {
      Future.sync(() async {

        _anotacaoModel = await useCases.getByIdUseCase(id: widget.id!);

        _title.text = _anotacaoModel!.titulo!;
        _obs.text = _anotacaoModel!.observacao!;

        setState(() {
          if (_anotacaoModel!.imagemFundo != null && _anotacaoModel!.imagemFundo!.isNotEmpty) {
            _pathImage = _anotacaoModel!.imagemFundo!;
            ConfigApp.of(context).removeBackground = true;
          }

          if (_anotacaoModel!.cor != null && _anotacaoModel!.cor!.isNotEmpty) {
            ConfigApp.of(context).color = Color(int.parse("0xFF${_anotacaoModel!.cor}"));
          }
        });
      });
    }
    
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
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
        errorStyle: TextStyle(color: ConfigApp.of(context).color),
        hintStyle: TextStyle(
          color: ConfigApp.of(context).color,
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),
        border: InputBorder.none, 
      ),
      style: TextStyle(
        color: ConfigApp.of(context).color,
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
        errorStyle: TextStyle(color: ConfigApp.of(context).color),
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: ConfigApp.of(context).color,
        fontSize: 18.0
      ),
      minLines: 10,
      maxLines: null,
      keyboardType: TextInputType.multiline,
    );
  }

  Widget _home() {
    return Container(
      padding: EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        child: Builder(
          builder: (BuildContext context) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _titulo(),
                  _descricao(),
                ],
              ),
            );
          },
        ),
      ),
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
            _anotacaoModel!.imagemFundo = _pathImage;
            _anotacaoModel!.cor = _cor.text.isNotEmpty ? _cor.text : _anotacaoModel!.cor;
            _updateNote(_anotacaoModel!);
          }

          widget.setState();
        }
      },
      child: Icon(Icons.save),
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(10.0),
        title: Text("Cor das letras"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
              pickerColor: ConfigApp.of(context).color,
              onColorChanged: changeColor,
              showLabel: false,
              enableAlpha: false,
              pickerAreaBorderRadius: BorderRadius.all(Radius.circular(15.0)),
              pickerAreaHeightPercent: 0.7,
              hexInputController: _cor,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  void changeColor(Color color) {
    setState(() {
      ConfigApp.of(context).color = color;
      _pathImage.isNotEmpty ? ConfigApp.of(context).removeBackground = true : ConfigApp.of(context).removeBackground = false;
    });
  }

  void _insertNote() async {
    AnotacaoModel anotacaoModel = AnotacaoModel(
      titulo: _title.text,
      observacao: _obs.text,
      data: DateTime.now().toIso8601String(),
      imagemFundo: _pathImage,
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

  void _updatePathImage(String path) {
    setState(() {
      _pathImage = path;
    });
  }

  Widget _body() {
    return Stack(
      children: [
        Container(
          decoration: _pathImage.isEmpty ? null : BoxDecoration(
            image: DecorationImage(
              image: _pathImage.contains('lib') ?
                AssetImage(_pathImage) as ImageProvider :
                FileImage(File(_pathImage)),
              fit: BoxFit.fill,
            ),
          ),
          width: double.infinity,
          height: double.infinity,
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
       ConfigApp.of(context).removeBackground = false;
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: AppBarCreate(
            updateImage: _updatePathImage,
            showColorPicker: _showColorPicker,
            pathImage: _pathImage,
          ),
          preferredSize: Size.fromHeight(56.0),
        ),
        body: _body(),
        floatingActionButton: _button(),
      ),
    );
  }
}