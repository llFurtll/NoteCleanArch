import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/data/repositories/config_repository.dart';
import 'package:note/data/repositories/crud_repository.dart';
import 'package:note/domain/usecases/config_user_usecases.dart';
import 'package:note/domain/usecases/crud_usecases.dart';
import 'package:note/presentation/pages/createpage/create.dart';
import 'package:note/presentation/pages/homepage/card.dart';
import 'package:note/core/config_app.dart';

import 'animated_list.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {

  late CrudUseCases useCases;
  late ConfigUserUseCases configUserUseCases;
  Timer? _debounce;

  late FocusNode _focusNode;

  final double _fabDimension = 56.0;

  TextEditingController _textController = TextEditingController();
  final TextEditingController _name = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _userName = "Digite seu nome aqui :)";
  late bool _carregando;
  List<Widget> _listaCardNote = [];

  ContainerTransitionType _transitionType = ContainerTransitionType.fadeThrough;

  @override
  void initState() {
    super.initState();

    _carregando = true;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      useCases = CrudUseCases(
        repository: CrudRepository(datasourceBase: ConfigApp.of(context).datasourceBase)
      );

      configUserUseCases = ConfigUserUseCases(
        configRepository: ConfigUserRepository(datasourceBase: ConfigApp.of(context).datasourceBase)
      );

      Future.sync(() async {
        String? nomeUser = await configUserUseCases.getName();
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

  Future<void> _showModal() async {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: 200.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
          ),
          child: Column(     
            children: [
              Container(
                height: 50.0,
                child: Icon(Icons.drag_handle, size: 45.0, color: Colors.grey),
              ), 
              Container(
                alignment: Alignment.center,
                height: 150.0,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextFormField(
                  autofocus: true,
                  onFieldSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      int? update = await configUserUseCases.updateName(name: _name.text);

                      if (update != 0) {
                        Navigator.of(context).pop();
                      }

                      _userName = await configUserUseCases.getName();

                      setState(() {});
                    } else {
                      Navigator.of(context).pop();
                      _name.text = _userName!;
                    }
                  },
                  controller: _name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ),
      )
    );
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
            setState: () async {
              setState(() {
                _carregando = true;
              });
              _listaCardNote = await _getNotes();
              setState(() {
                _carregando = false;
              });
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
    return SliverAppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0))
      ),
      backgroundColor: Colors.white,
      expandedHeight: 300.0,
      floating: true,
      pinned: true,
      snap: false,
      forceElevated: true,
      elevation: 5.0,
      flexibleSpace: Container(
        child: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.yellow,
                    radius: 50.0,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white
                            ),
                            child: Icon(Icons.camera, color: Theme.of(context).primaryColor, size: 30.0),
                          ),
                        )
                      ]
                    ),
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
                      _showModal();
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
    return Builder(
      builder: (context) {
        if (_carregando) {
          print("LEGAL");
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)
            )
          );
        } else if (_listaCardNote.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("lib/images/sem-anotacao.svg", width: 100.0, height: 100.0),
                Text(
                  "Sem anotações!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.grey
                  ),
                )
              ],
            )
          );
        } else {
          print("LEGAL2");
          // return ListView(
          //   padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 15.0),
          //   children: _listaCardNote,
          //   shrinkWrap: true,
          //   scrollDirection: Axis.vertical,
          // );

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                // return ListView(
                //   padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 15.0),
                //   children: _listaCardNote,
                //   shrinkWrap: true,
                //   scrollDirection: Axis.vertical,
                // );
              }
            ),
          );
        }
      },
    );
  }

  Widget _top2() {
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
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.yellow,
                    radius: 35.0,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white
                            ),
                            child: Icon(Icons.camera, color: Theme.of(context).primaryColor),
                          ),
                        )
                      ]
                    ),
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
                      _showModal();
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

  Widget _listaNote2() {
    return Positioned(
      top: 280.0,
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Builder(
        builder: (context) {
          if (_carregando) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)
              )
            );
          } else if (_listaCardNote.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("lib/images/sem-anotacao.svg", width: 100.0, height: 100.0),
                  Text(
                    "Sem anotações!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Colors.grey
                    ),
                  )
                ],
              )
            );
          } else {
            return ListView(
              padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 15.0),
              children: _listaCardNote,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
            );
          }
        },
      )
    );
  }

  Widget _home() {
    // return Stack(
    //   children: [
    //     _top(),
    //     _listaNote()
    //   ],
    // );
    return CustomScrollView(
      slivers: <Widget>[
        _top(),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _listaCardNote[index],
            childCount: _listaCardNote.length,
          )
        ),
      ],
    );
  }

  OpenContainer _button() {
    return OpenContainer(
      openColor: Theme.of(context).floatingActionButtonTheme.backgroundColor!,
      closedColor: Theme.of(context).floatingActionButtonTheme.backgroundColor!,
      closedElevation: 6.0,
      openElevation: 0.0,
      transitionType: _transitionType,
      transitionDuration: Duration(milliseconds: 500),
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(_fabDimension / 2)),
      ),
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return FloatingActionButton(
          backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          elevation: 0.0,
          onPressed: null,
          child: Icon(Icons.add),
        );
      },
      openBuilder: (BuildContext context, VoidCallback _) {
        return CreateNote(
          setState: () async {
            setState(() {
              _carregando = true;
            });
            _listaCardNote = await _getNotes();
            setState(() {
              _carregando = false;
            });
          }
        );
      }
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