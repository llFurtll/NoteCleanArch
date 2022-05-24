import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';

import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../../createpage/create.dart';
import '../../../../domain/usecases/crud_usecases.dart';
import 'app_bar_create_component.dart';

class ChangeImageBackgroundComponent implements IComponent<CreateNoteState, Container, void> {

  final CreateNoteState _screen;
  final _imageSelected = ValueNotifier<int>(-1);
  final CompManagerInjector injector = CompManagerInjector();

  late List<String> _assetsImages;
  late final CrudUseCases _useCases;
  late final AppBarCreateComponent _appBarCreateComponent;

  ChangeImageBackgroundComponent(this._screen) {
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
  Container constructor() {
    return Container();
  }

  @override
  void event() {
    showModalBottomSheet(
      context: _screen.context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(15.0),
          height: 200.0,
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ..._returnCardsImage().map((item) {
                  return item;
                })
              ],
            ),
          )
        );
      }
    );
  }

  @override
  void init() async {
    _useCases = injector.getDependencie();
    _assetsImages = await _listAllAssetsImage();
    _appBarCreateComponent = _screen.getComponent(AppBarCreateComponent) as AppBarCreateComponent;
  }

  Future<List<String>> _listAllAssetsImage() async {
    List<String> assetImages = [];

    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    Directory((await getApplicationDocumentsDirectory()).path).listSync().forEach((element) {
      if (element.path.contains('jpg')) {
        assetImages.add(element.path);
      }
    });
    
    assetImages.addAll(
      manifestMap.keys
      .where((String key) => key.contains('lib/images/'))
      .where((String key) => key.contains('.jpg'))
      .toList()
    );

    return assetImages;
  }

  List<Widget> _returnCardsImage() {
    List<Widget> lista = [];
    _assetsImages.asMap().forEach((index, element) {
      lista.add(_buildCardImage(element, index));
    });

    lista.add(_addPhoto());

    return lista;
  }

  GestureDetector _buildCardImage(String image, int index) {
    if (_screen.pathImage.isNotEmpty) {
      if (image == _screen.pathImage) {
        _imageSelected.value = index;
      }
    }
    return GestureDetector(
      onTap: () {
        if (image != _screen.pathImage) {
          _screen.pathImage = image;
          _imageSelected.value = index;
          _appBarCreateComponent.removeBackground = true;
        }
      },
      onLongPress: () {
        if (!image.contains('lib')) {
          showDialog(
            context: _screen.context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Deletar imagem?", style: TextStyle(color: _screen.color)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Não",
                      style: TextStyle(
                        color: _screen.color,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                  TextButton(
                    onPressed: () async {
                      File(image).delete();

                      int? update = await _useCases.removeBackgroundNote(image: image);
                      _assetsImages = await _listAllAssetsImage();
                      
                      if (update != 0) {
                        _screen.pathImage = "";
                      }

                      if (update == 0 && !image.contains('lib')) {
                        _screen.pathImage = "";
                      }

                      _imageSelected.value = -1;
                      
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Sim",
                      style: TextStyle(
                        color: _screen.color,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  )
                ],
              );
            }
          );
        }
      },
      child: ValueListenableBuilder(
        valueListenable: _imageSelected,
        builder: (_, value, __) {
          return Container(
            margin: const EdgeInsets.only(right: 15.0),
            width: 120.0,
            height: 150.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: image.contains('lib') ? AssetImage(image) as ImageProvider : FileImage(File(image)),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15.0),
              border: _imageSelected.value == index ? Border.all(
                color: Colors.blueAccent, width: 10.0
              ) : null
            ),
          );
        },
      )
    );
  }

  Widget _addPhoto() {
    return Container(
      margin: const EdgeInsets.only(right: 15.0),
      width: 120.0,
      height: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.grey,
      ),
      child: Center(
        child: IconButton(
          onPressed: () => {},
          icon: Icon(Icons.camera, color: Colors.white, size: 40.0),
        ),
      ),
    );
  }
}