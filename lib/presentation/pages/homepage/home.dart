import 'package:flutter/material.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/domain/usecases/usecases.dart';
import 'package:note/presentation/pages/createpage/create.dart';
import 'package:note/presentation/pages/homepage/appbar.dart';
import 'package:note/presentation/pages/homepage/card.dart';
import 'package:note/utils/route_animation.dart';

class Home extends StatefulWidget {
  final UseCases useCase;

  Home({required this.useCase});
  
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  Future<List<Widget>> _getNotes() async {
    List<AnotacaoModel?> listaAnotacao = await widget.useCase.findAlluseCase();
    List<Widget> _listaNote = [];

    listaAnotacao.forEach((anotacao) {
      _listaNote.add(
        CardNote(
          anotacaoModel: anotacao!,
          useCase: widget.useCase,
          removeNote: () {
            removeNote(anotacao.id!);
          },
          updateSituacao: () {
            updateSituacao(anotacao);
          },
        ),
      );
    });

    return _listaNote;
  }

  void removeNote(int id) async {
    int? delete = await widget.useCase.deleteUseCase(id: id);
    
    if (delete == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text("Anotacão deletada com sucesso!"),
          action: SnackBarAction(
            label: "Fechar",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );

      setState(() {});
    }
  }

  void updateSituacao(AnotacaoModel anotacaoModel) async {
    int? update = await widget.useCase.updateSituacaoUseCase(anotacao: anotacaoModel);
    
    if (update != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text("Anotacão finalizada com sucesso!"),
          action: SnackBarAction(
            label: "Fechar",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );

      setState(() {});
    }
  }

  Widget _home() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: FutureBuilder<List<Widget>>(
        future: _getNotes(),
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
            default:
            if (snapshot.hasError) {
              return Center(child: Text("Erro ao carregar os dados"));
            } else {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text("Sem anotações!"),
                );
              } else {
                return ListView(
                  children: snapshot.data!,
                );
              }
            }
          }
        },
      ),
    );
  }

  FloatingActionButton _button() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      onPressed: () => Navigator.of(context).push(
        createRoute(
          CreateNote(
            useCase: widget.useCase,
            setState: () {
              setState(() {});
            },
          )
        )
      ),
      child: Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBarHome(titulo: "Note"),
        preferredSize: Size.fromHeight(56.0),
      ),
      body: _home(),
      floatingActionButton: _button(),
    );
  }
}