import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/data/repositories/crud_repository.dart';
import 'package:note/domain/usecases/usecases.dart';
import 'package:note/presentation/pages/createpage/config_app.dart';
import 'package:note/presentation/pages/createpage/create.dart';
import 'package:note/presentation/pages/homepage/card.dart';
import 'package:note/utils/route_animation.dart';

import 'animated_list.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {

  late UseCases useCases;
  Timer? _debounce;
  late FocusNode _focusNode;
  TextEditingController _textController = TextEditingController();

  @override
  void didChangeDependencies() {
    useCases = UseCases(
      repository: CrudRepository(datasourceBase: ConfigApp.of(context).datasourceBase)
    );

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();

    super.dispose();
  }

  void _onSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  Future<List<Widget>> _getNotes() async {
    List<AnotacaoModel?> _listaAnotacao = [];
    if (_textController.text.isNotEmpty) {
      _listaAnotacao = await useCases.findWithDesc(desc: _textController.text);
    } else {
      _listaAnotacao = await useCases.findAlluseCase();
    }
    
    List<Widget> _listaNote = [];

    _listaAnotacao.forEach((anotacao) {
      _listaNote.add(
        CardNote(
          anotacaoModel: anotacao!,
          setState: () {
            setState(() {});
          },
          focus: _focusNode,
        ),
      );
    });

    return _listaNote;
  }

  Widget _top() {
    return Positioned(
      top: 0.0,
      height: 320.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.yellow,
                    radius: 35.0,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text("Daniel Melonari",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    focusNode: _focusNode,
                    controller: _textController,
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: "Pesquisar anotação",
                      suffixIcon: Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.white
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white
                        )
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white
                        )
                      ),
                      hintStyle: TextStyle(
                        color: Colors.white54
                      ),
                    ),
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0)),
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _listaNote() {
    return Positioned(
      top: 270.0,
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: FutureBuilder(
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
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Align(child: AnimatedListItem(index, snapshot.data![index]));
                  },
                );
              }
            }
          }
        },
      ),
    );
  }

  Widget _home() {
    return Stack(
      children: [
        _top(),
        _listaNote()
      ],
    );
  }

  FloatingActionButton _button() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      onPressed: () {
        _focusNode.unfocus();
        Navigator.of(context).push(
          createRoute(
            CreateNote(
              setState: () {
                setState(() {});
              },
            )
          )
        );
      },
      child: Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: _home(),
      ),
      floatingActionButton: _button(),
    );
  }
}