import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../../../../../../core/notifiers/change_notifier_global.dart';
import '../../../../../../core/dependencies/repository_injection.dart';
import '../../../../../config_app/presentation/pages/principal/config_app_list.dart';
import '../../../../../config_user/domain/usecases/config_user_use_case.dart';
import '../../info/info.dart';
import '../home_list.dart';
import 'alter_name_component.dart';
import 'list_component.dart';
import 'alter_photo_profile_component.dart';

class HeaderComponent implements IComponent<HomeListState, SliverAppBar, void> {

  final CompManagerInjector injector = CompManagerInjector();
  final HomeListState _screen;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ChangeNotifierGlobal<String?> _userNameNotifier = ChangeNotifierGlobal("Digite seu nome aqui :)");
  final ChangeNotifierGlobal<bool> _showMenu = ChangeNotifierGlobal(true);
  
  late final AlterNameComponent _alterNameComponent;
  late final ListComponent _listComponent;
  late final AlterPhotoProfileComponent _alterPhotoProfileComponent;
  late final ConfigUserUseCase _configUserUseCase;

  ChangeNotifierGlobal<String?> _imagePath = ChangeNotifierGlobal("");
  Timer? _debounce;
  bool _showName = false;

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
      automaticallyImplyLeading: false,
      actions: _actions(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(50.0)
        )
      ),
      backgroundColor: Theme.of(_screen.context).primaryColor,
      expandedHeight: 300.0,
      toolbarHeight: 50,
      floating: true,
      pinned: true,
      centerTitle: true,
      snap: false,
      forceElevated: true,
      elevation: 5.0,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          _verifySize(constraints);

          return FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            title: Visibility(
              visible: _showName,
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
                        child: _profile()
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: _nameUser()
                      ),
                      _search()
                    ],
                  ),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0)),
                color: Theme.of(_screen.context).primaryColor,
              ),
            ),
          );
        },
      ),
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
    _screen.addComponent(this);
    _alterNameComponent = AlterNameComponent(_screen);
    _alterPhotoProfileComponent = AlterPhotoProfileComponent(_screen);
    _listComponent = _screen.getComponent(ListComponent) as ListComponent;
  }

  @override
  void bindings() {
    _configUserUseCase = ConfigUserUseCase(repository: RepositoryInjection.of(_screen.context)!.configUserRepository);
  }

  @override
  void dispose() {
    _focusNode.dispose();
  }

  @override
  Future<void> loadDependencies() async {
    await loadName();
  }

  String? get userName {
    return _userNameNotifier.value;
  }

  set userName(String? name) {
    _userNameNotifier.value = name;
  }

  void removeFocusNode() {
    _focusNode.unfocus();
  }

  String? get imagePath {
    return _imagePath.value;
  }

  set imagePath(String? path) {
    _imagePath.value = path;
  }

  Future<void> loadName() async {
    String? nomeUser = await _configUserUseCase.getName();

    if (nomeUser!.isNotEmpty) {
      _userNameNotifier.value = nomeUser;
    }
  }

  List<Widget> _actions() {
    return [
      ValueListenableBuilder(
        valueListenable: _showMenu,
        builder: (BuildContext context, bool value, Widget? widget)  {
          return Visibility(
            visible: _showMenu.value,
            child: _buildPopup()
          );
        },
      ),
    ];
  }

  PopupMenuButton _buildPopup() {
    return PopupMenuButton<int>(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      tooltip: "Menu",
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Configurações"),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: 2,
          child: Text("Sobre o desenvolvedor")
        )
      ],
      onSelected: (int index) {
        switch (index) {
          case 1:
            Navigator.of(_screen.context).pushNamed(ConfigAppList.routeConfigAppList);
            break;
          default:
            Navigator.of(_screen.context).pushNamed(Info.routeInfo);
            break;
        }
      },
    );
  }

  void _verifySize(BoxConstraints constraints) {
    var _height = MediaQuery.of(_screen.context).padding.top;
    var _top = constraints.biggest.height;
    if (_top == _height + 50) {
      _showName = true;
      Future.delayed(Duration(milliseconds: 50), () => _showMenu.value = false);
    } else {
      _showName = false;
      Future.delayed(Duration(milliseconds: 50), () => _showMenu.value = true);
    }
  }

  GestureDetector _profile() {
    return GestureDetector(
      onTap: () => _screen.emitScreen(_alterPhotoProfileComponent),
      child: ValueListenableBuilder(
        valueListenable: _imagePath,
        builder: (BuildContext context, String? value, Widget? widget) {
          return CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: 
              _imagePath.value!.isNotEmpty ? FileImage(File(_imagePath.value!)) :
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
                _imagePath.value!.isEmpty ?
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
          );
        },
      ),
    ); 
  }

  TextButton _nameUser() {
    return TextButton(
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
      onPressed: () => _screen.emitScreen(_alterNameComponent),
    );
  }

  Container _search() {
    return Container(
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
    );
  }
}