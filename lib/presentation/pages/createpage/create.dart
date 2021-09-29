import 'package:flutter/material.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/domain/usecases/usecases.dart';
import 'package:note/presentation/pages/createpage/appbar.dart';

class CreateNote extends StatefulWidget {
  final UseCases useCase;
  final Function setState;

  CreateNote({required this.useCase, required this.setState});

  @override
  CreateNoteState createState() => CreateNoteState();
}

class CreateNoteState extends State<CreateNote> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _obs = TextEditingController();

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
        hintStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: Colors.black,
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
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: Colors.black,
        fontSize: 18.0
      ),
      minLines: 20,
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
          AnotacaoModel anotacaoModel = AnotacaoModel(
          titulo: _title.text,
          observacao: _obs.text,
          data: DateTime.now().toIso8601String(),
          imagemFundo: "",
          situacao: 1
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

            widget.setState();

            Navigator.of(context).pop();
          }
        }
      },
      child: Icon(Icons.save),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: AppBarCreate(),
        preferredSize: Size.fromHeight(56.0),
      ),
      body: _home(),
      floatingActionButton: _button(),
    );
  }
}