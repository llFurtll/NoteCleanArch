import 'package:flutter/material.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/domain/usecases/usecases.dart';
import 'package:note/presentation/pages/createpage/appbar.dart';

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

  TextEditingController _title = TextEditingController();
  TextEditingController _obs = TextEditingController();
  String pathImage = "";


  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      Future.sync(() async {
        _anotacaoModel = await widget.useCase.getByIdUseCase(id: widget.id!);

        _title.text = _anotacaoModel!.titulo!;
        _obs.text = _anotacaoModel!.observacao!;
        setState(() {
          if (_anotacaoModel!.imagemFundo != null) {
            pathImage = _anotacaoModel!.imagemFundo!;
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
      minLines: 50,
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
            insertNote(_title.text, _obs.text, widget.useCase, context);
          } else {
            _anotacaoModel!.titulo = _title.text;
            _anotacaoModel!.observacao = _obs.text;
            _anotacaoModel!.imagemFundo = pathImage;
            updateNote(_anotacaoModel!, widget.useCase, context);
          }

          widget.setState();

          Navigator.of(context).pop();
        }
      },
      child: Icon(Icons.save),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: AppBarCreate(updateImage: updatePathImage),
        preferredSize: Size.fromHeight(56.0),
      ),
      body: Stack(
        children: [
          Container(
            decoration: pathImage.isEmpty ? null : BoxDecoration(
              image: DecorationImage(
                image: AssetImage(pathImage),
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
    );
  }

  void insertNote(String title, String obs, UseCases useCase, BuildContext context) async {
    AnotacaoModel anotacaoModel = AnotacaoModel(
      titulo: title,
      observacao: obs,
      data: DateTime.now().toIso8601String(),
      imagemFundo: pathImage,
      situacao: 1
    );
    
    int? insert = await useCase.insertUseCase(anotacao: anotacaoModel);

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

  void updateNote(AnotacaoModel anotacao, UseCases useCase, BuildContext context) async {
    int? updated = await useCase.updateUseCase(anotacao: anotacao);

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

  void updatePathImage(String path) {
    setState(() {
      pathImage = path;
    });
  }
}