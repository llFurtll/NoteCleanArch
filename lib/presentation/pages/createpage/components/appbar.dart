import 'dart:convert';
import 'dart:io';
import 'package:compmanager/core/compmanager_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note/domain/usecases/crud_usecases.dart';
import 'package:path_provider/path_provider.dart';

import 'package:note/core/config_app.dart';

import '../../../../core/camera_gallery.dart';

class AppBarCreate extends StatefulWidget {
  final Function(String pathImage) updateImage;
  final Function showColorPicker;
  final String? pathImage;

  AppBarCreate({required this.updateImage, required this.showColorPicker, this.pathImage});

  @override
  AppBarCreateState createState() => AppBarCreateState();
}

class AppBarCreateState extends State<AppBarCreate> {

  final CompManagerInjector injector = CompManagerInjector();

  final _imageSelected = ValueNotifier<int>(-1);

  late CrudUseCases _useCases;
  late List<String> _assetsImages;

  @override
  void initState() {
    super.initState();

    _useCases = injector.getDependencie();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Future.sync(() async {
        _assetsImages = await _listAllAssetsImage();
      });
    });
  }

  @override
  void dispose() {
    _imageSelected.dispose();
    super.dispose();
  }

  PersistentBottomSheetController? _controller;

  void showOptionsPhoto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CameraGallery(
          updateImage: widget.updateImage,
          setState: () async {
            _assetsImages = await _listAllAssetsImage();
            _controller!.setState!(() {});
            ConfigApp.of(context).removeBackground = true;
            Navigator.of(context).pop();
          },
        );
      }
    );
  }

  List<Widget> _actions() {
    return [
    IconButton(
        icon: Icon(Icons.color_lens),
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
        color: ConfigApp.of(context).color,
        onPressed: () {
          widget.showColorPicker();
        },
      ),
      Visibility(
        visible: ConfigApp.of(context).removeBackground,
        child: IconButton(
          color: ConfigApp.of(context).color,
          padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
          onPressed: () {
            widget.updateImage("");
            if (_controller != null) {
                _imageSelected.value = -1;
            }
            ConfigApp.of(context).removeBackground = false;
          },
          icon: Icon(Icons.close)
        )
      ),
      IconButton(
        padding: const EdgeInsets.fromLTRB(0, 25, 10, 25),
        onPressed: () {
          _controller = Scaffold.of(context).showBottomSheet((context) => Container(
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
          ));
        },
        icon: Icon(
          Icons.photo,
          color: ConfigApp.of(context).color,
        ),
      ),
    ];
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

  IconButton _iconLeading() {
    return IconButton(
      padding: const EdgeInsets.all(25.0),
      icon: Icon(
        Icons.arrow_back_ios,
        color: ConfigApp.of(context).color
      ),
      onPressed: () {
        Navigator.pop(context);
        ConfigApp.of(context).removeBackground = false;
        ConfigApp.of(context).color = Color(0xFF000000);
      },
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
          onPressed: () => showOptionsPhoto(),
          icon: Icon(Icons.camera, color: Colors.white, size: 40.0),
        ),
      ),
    );
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
    if (widget.pathImage!.isNotEmpty) {
      if (image == widget.pathImage) {
        _imageSelected.value = index;
      }
    }
    return GestureDetector(
      onTap: () {
        if (image != widget.pathImage) {
          widget.updateImage(image);
          _imageSelected.value = index;
          ConfigApp.of(context).removeBackground = true;
        }
      },
      onLongPress: () {
        if (!image.contains('lib')) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Deletar imagem?", style: TextStyle(color: ConfigApp.of(context).color)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Não",
                      style: TextStyle(
                        color: ConfigApp.of(context).color,
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
                        widget.updateImage("");
                        ConfigApp.of(context).removeBackground = false;
                      }

                      if (update == 0 && !image.contains('lib')) {
                        widget.updateImage("");
                        ConfigApp.of(context).removeBackground = false;
                      }

                      _imageSelected.value = -1;
                      
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Sim",
                      style: TextStyle(
                        color: ConfigApp.of(context).color,
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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: _actions(),
      leading: _iconLeading(),
    );
  }
}