import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/domain/usecases/usecases.dart';
import 'package:note/presentation/pages/createpage/appbar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CreateNote extends StatefulWidget {
  final UseCases useCase;
  final Function setState;
  final int? id;

  CreateNote({required this.useCase, required this.setState, this.id});

  @override
  CreateNoteState createState() => CreateNoteState();
}

class CreateNoteState extends State<CreateNote> {

  final _formKey = GlobalKey<FormState>();
  late AnotacaoModel? _anotacaoModel;

  Color _colorNote = Color(0xFF000000);

  TextEditingController _title = TextEditingController();
  TextEditingController _obs = TextEditingController();
  TextEditingController _cor = TextEditingController();
  String _pathImage = "";

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      Future.sync(() async {
        _anotacaoModel = await widget.useCase.getByIdUseCase(id: widget.id!);

        _title.text = _anotacaoModel!.titulo!;
        _obs.text = _anotacaoModel!.observacao!;

        setState(() {
          if (_anotacaoModel!.imagemFundo != null && _anotacaoModel!.imagemFundo!.isNotEmpty) {
            _pathImage = _anotacaoModel!.imagemFundo!;
            AppBarCreate.removeBackground = true;
          }

          if (_anotacaoModel!.cor != null && _anotacaoModel!.cor!.isNotEmpty) {
            _colorNote = Color(int.parse("0xFF${_anotacaoModel!.cor}"));
            AppBarCreate.color = _colorNote;
          }
        });
      });
    }
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
        errorStyle: TextStyle(color: _colorNote),
        hintStyle: TextStyle(
          color: _colorNote,
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),
        border: InputBorder.none, 
      ),
      style: TextStyle(
        color: _colorNote,
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
        errorStyle: TextStyle(color: _colorNote),
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: _colorNote,
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
        contentPadding: EdgeInsets.all(10.0),
        title: Text("Cor das letras"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
              pickerColor: _colorNote,
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
      _colorNote = color;
      AppBarCreate.color = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppBarCreate.color = Color(0xFF000000);
        AppBarCreate.removeBackground = false;
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
            useCase: widget.useCase,
          ),
          preferredSize: Size.fromHeight(56.0),
        ),
        body: Stack(
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
        ),
        floatingActionButton: _button(),
      ),
    );
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
    
    int? insert = await widget.useCase.insertUseCase(anotacao: anotacaoModel);

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
    int? updated = await widget.useCase.updateUseCase(anotacao: anotacao);

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
      widget.setState();
    });
  }
}