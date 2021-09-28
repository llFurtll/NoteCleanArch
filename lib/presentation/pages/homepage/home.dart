import 'package:flutter/material.dart';
import 'package:note/data/datasources/sqlite.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/data/repositories/crud_repository.dart';
import 'package:note/domain/usecases/usecases.dart';
import 'package:note/presentation/pages/createpage/create.dart';
import 'package:note/presentation/pages/homepage/appbar.dart';
import 'package:note/presentation/pages/homepage/card.dart';
import 'package:note/utils/route_animation.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  final Database db;

  Home({required this.db});
  
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {


  GlobalKey<ScaffoldState> _homeState = new GlobalKey();

  late SqliteDatasource _datasource;
  late CrudRepository _repository;
  late UseCases _useCases;

  @override
  void initState() {
    super.initState();

    _datasource = SqliteDatasource(db: widget.db);
    _repository = CrudRepository(datasourceBase: _datasource);
    _useCases = UseCases(repository: _repository);
  }

  Future<List<Widget>> _getNotes() async {
    List<AnotacaoModel?> listaAnotacao = await _useCases.findAlluseCase();
    List<Widget> _listaNote = [];

    listaAnotacao.forEach((anotacao) {
      _listaNote.add(
        CardNote(
          anotacaoModel: anotacao!,
        ),
      );
    });

    return _listaNote;
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
              return ListView(
                children: snapshot.data!,
              );
            }
          }
        },
      ),
    );
  }

  FloatingActionButton _button() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      onPressed: () => Navigator.of(context).push(createRoute(CreateNote(db: widget.db, key: _homeState))),
      child: Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _homeState,
      appBar: PreferredSize(
        child: AppBarHome(titulo: "Note"),
        preferredSize: Size.fromHeight(56.0),
      ),
      body: _home(),
      floatingActionButton: _button(),
    );
  }
}