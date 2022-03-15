import 'dart:async';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note/core/camera_gallery.dart';
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

  final _formKey = GlobalKey<FormState>();

  late CrudUseCases useCases;
  late ConfigUserUseCases configUserUseCases;

  Timer? _debounce;

  late FocusNode _focusNode;
  final double _fabDimension = 56.0;
  bool _showTitle = false;

  final TextEditingController _textController = TextEditingController();
  final TextEditingController _name = TextEditingController();

  final ScrollController _customController = ScrollController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _userName = "Digite seu nome aqui :)";
  String? _imagePath = "";
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

        _imagePath = await configUserUseCases.getImage();

        _listaCardNote = await _getNotes();
      });
    });

    _focusNode = FocusNode();

    _customController.addListener(_collapsedOrScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    _customController.dispose();

    super.dispose();
  }

  void _collapsedOrScroll() {
    if (_customController.offset.ceil() == 258) {
      setState(() {
        _showTitle = true;
      });
    } else {
      setState(() {
        _showTitle = false;
      });
    }
  }

  void showOptionsPhoto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CameraGallery(
          useCase: configUserUseCases,
          setState: () async {
            Navigator.of(context).pop();
            _imagePath = await configUserUseCases.getImage();
            setState(() {});
          },
          removerImagem: _imagePath!.isNotEmpty,
        );
      }
    );
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50.0,
                child: Icon(Icons.drag_handle, size: 45.0, color: Colors.grey),
              ), 
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor preencha o título!";
                      }

                      return null;
                    },
                    autofocus: true,
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
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                height: 50.0,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      int? update = await configUserUseCases.updateName(name: _name.text);

                      if (update != 0) {
                        Navigator.of(context).pop();
                      }

                      _userName = await configUserUseCases.getName();

                      setState(() {});
                    }
                  },
                  child: Text("Salvar")
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
      backgroundColor: Theme.of(context).primaryColor,
      expandedHeight: 300.0,
      floating: true,
      pinned: true,
      centerTitle: true,
      snap: false,
      forceElevated: true,
      elevation: 5.0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        title: Visibility(
          visible: _showTitle,
          child: Text(_userName!),
        ),
        centerTitle: true,
        background: Container(
          child: Center(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                    child: GestureDetector(
                      onTap: () => showOptionsPhoto(),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: 
                          _imagePath!.isNotEmpty ? FileImage(File(_imagePath!)) :
                          null,
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
                            ),
                            _imagePath!.isEmpty ?
                              Center(
                                child: Text(
                                  "SEM FOTO",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ) :
                              Text("") 
                          ]
                        ),
                      ),
                    )
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
      )
    );
  }

  Widget _listaNote() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (_carregando) {
            return SizedBox(
              height:  MediaQuery.of(context).size.height - 350,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)
                )
              ),
            );
          } else if (_listaCardNote.length == 0) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
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
              ),
            );
          } else {
            return _listaCardNote[index];
          }
        },
        childCount: _listaCardNote.length > 0 ? _listaCardNote.length : 1,
      )
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

  Widget _home() {
    return CustomScrollView(
      controller: _customController,
      slivers: <Widget>[
        _top(),
        _listaNote(),
      ],
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