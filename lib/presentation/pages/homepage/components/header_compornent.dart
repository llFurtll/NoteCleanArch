import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../home.dart';
import 'alter_name_component.dart';
import '../../../../domain/usecases/config_user_usecases.dart';
import 'list_component.dart';

class HeaderComponent implements IComponent<HomeState, SliverAppBar, void> {

  final CompManagerInjector injector = CompManagerInjector();
  final HomeState _screen;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<String?> _userNameNotifier = ValueNotifier("Digite seu nome aqui :)");
  
  bool _showTitle = false;
  String? _imagePath = "";
  Timer? _debounce;
  
  late final ConfigUserUseCases _configUserUseCases;
  late final AlterNameComponent _alterNameComponent;
  late final ListComponent _listComponent;

  HeaderComponent(this._screen) {
    init();
  }

  @override
  void afterEvent() {
    return;
  }

  @override
  void beforeEvent() {
    return;
  }

  @override
  SliverAppBar constructor() {
    return SliverAppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0))
      ),
      backgroundColor: Theme.of(_screen.context).primaryColor,
      expandedHeight: 300.0,
      collapsedHeight: 50,
      toolbarHeight: 50,
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
          child: Text(_userNameNotifier.value!),
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
                      onTap: () => () {},
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
                                child: Icon(Icons.camera, color: Theme.of(_screen.context).primaryColor, size: 30.0),
                              ),
                            ),
                            _imagePath!.isEmpty ?
                              Center(
                                child: Text(
                                  "SEM FOTO",
                                  style: TextStyle(
                                    color: Theme.of(_screen.context).primaryColor,
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
                          ValueListenableBuilder(
                            valueListenable: _userNameNotifier,
                            builder: (BuildContext context, String? value, Widget? widget) {
                              return Text(
                                _userNameNotifier.value!,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0)
                              );
                            }
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.edit, color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _screen.emitScreen(_alterNameComponent);
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(_screen.context).size.width * 0.7,
                    child: TextFormField(
                      focusNode: _focusNode,
                      controller: _textController,
                      onChanged: (String value) => _screen.emitScreen(this),
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
            color: Theme.of(_screen.context).primaryColor,
          ),
        ),
      )
    );
  }

  @override
  void event() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      await _listComponent.getNotes(_textController.text);
    });
  }

  @override
  void init() async {
    _configUserUseCases = injector.getDependencie<ConfigUserUseCases>();
    _imagePath = await _configUserUseCases.getImage();
    _loadName();
    _alterNameComponent = AlterNameComponent(_screen);
    _listComponent = _screen.getComponent(ListComponent) as ListComponent;
  }

  void _loadName() async {
    String? nomeUser = await _configUserUseCases.getName();

    if (nomeUser!.isNotEmpty) {
      _userNameNotifier.value = nomeUser;
    }
  }

  String? get userName {
    return _userNameNotifier.value;
  }

  set setUserName(String? name) {
    _userNameNotifier.value = name;
  }

  void removeFocusNode() {
    _focusNode.unfocus();
  }
}