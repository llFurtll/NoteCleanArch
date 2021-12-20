import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/data/repositories/config_repository.dart';
import 'package:note/data/repositories/crud_repository.dart';
import 'package:note/domain/usecases/config_user_usecases.dart';
import 'package:note/domain/usecases/crud_usecases.dart';
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

  late CrudUseCases useCases;
  late ConfigUserUseCases configUseruseCases;
  Timer? _debounce;

  late FocusNode _focusNode;

  TextEditingController _textController = TextEditingController();
  final TextEditingController _name = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _userName = "Digite seu nome aqui :)";
  late bool _carregando;
  List<Widget> _listaCardNote = [];

  @override
  void initState() {
    super.initState();

    _carregando = true;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      useCases = CrudUseCases(
        repository: CrudRepository(datasourceBase: ConfigApp.of(context).datasourceBase)
      );

      configUseruseCases = ConfigUserUseCases(
        configRepository: ConfigUserRepository(datasourceBase: ConfigApp.of(context).datasourceBase)
      );

      Future.sync(() async {
        String? nomeUser = await configUseruseCases.getName();
        if (nomeUser!.isNotEmpty) {
          _userName = nomeUser;
          _name.text = nomeUser;
        }

        _listaCardNote = await _getNotes();
      });
    });

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
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        _carregando = true;
      });
      _listaCardNote = await _getNotes();
      setState(() {
        _carregando = false;
      });
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

    _listaAnotacao.asMap().forEach((index, anotacao) {
      _listaNote.add(
        Align(child: AnimatedListItem(
          index,
          CardNote(
            anotacaoModel: anotacao!,
            setState: () {
              setState(() {});
            },
            focus: _focusNode,
          ),
        ))
      );
    });

    setState(() {
      _carregando = false;
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
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: TextButton(
                    autofocus: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _userName!,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0)
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState!.showBottomSheet((context) => Container(
                          color: Colors.white,
                          height: 80.0,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 10.0),
                                  width: MediaQuery.of(context).size.width - 100,
                                  child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      controller: _name,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Por favor preencha o nome!";
                                        }

                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: const BorderSide(
                                            color: Colors.white
                                          )
                                        ),
                                      ),
                                    ),
                                  )
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      int? update = await configUseruseCases.updateName(name: _name.text);

                                      if (update != 0) {
                                        Navigator.of(context).pop();
                                      }

                                      Future.sync(() async {
                                        _userName = await configUseruseCases.getName();
                                      });
                                    }
                                  },
                                  child: Text("Salvar", style: TextStyle(color: Colors.white)),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      );
                    },
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
      child: Builder(
        builder: (context) {
          if (_carregando) {
            return Center(child: CircularProgressIndicator());
          } else if (_listaCardNote.isEmpty) {
            return Center(child: Text("Sem anotações!"),);
          } else {
            return ListView(
              padding: EdgeInsets.zero,
              children: _listaCardNote,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
            );
          }
        },
      )
      
      // FutureBuilder(
      //   future: _getNotes(),
      //   builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
      //       default:
      //       if (snapshot.hasError) {
      //         return Center(child: Text("Erro ao carregar os dados"));
      //       } else {
      //         if (snapshot.data!.isEmpty) {
      //           return Center(
      //             child: Text("Sem anotações!"),
      //           );
      //         } else {
      //           return ListView.builder(
      //             padding: EdgeInsets.zero,
      //             shrinkWrap: true,
      //             scrollDirection: Axis.vertical,
      //             itemCount: snapshot.data!.length,
      //             itemBuilder: (context, index) {
      //               
      //             },
      //           );
      //         }
      //       }
      //     }
      //   },
      // ),
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
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: _home(),
      ),
      floatingActionButton: _button(),
    );
  }
}