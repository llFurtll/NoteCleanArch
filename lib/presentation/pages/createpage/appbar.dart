import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note/data/repositories/crud_repository.dart';
import 'package:note/domain/usecases/crud_usecases.dart';
import 'package:path_provider/path_provider.dart';

import 'camera.dart';
import 'config_app.dart';

class AppBarCreate extends StatefulWidget {
  final Function(String pathImage) updateImage;
  final Function showColorPicker;
  final String? pathImage;

  AppBarCreate({required this.updateImage, required this.showColorPicker, this.pathImage});

  @override
  AppBarCreateState createState() => AppBarCreateState();
}

class AppBarCreateState extends State<AppBarCreate> {

  int? _imageSelected;

  late CrudUseCases _useCases;
  late List<String> _assetsImages;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _useCases = CrudUseCases(
        repository: CrudRepository(datasourceBase: ConfigApp.of(context).datasourceBase)
      );

      Future.sync(() async {
        _assetsImages = await _listAllAssetsImage();
      });
    });
  }

  PersistentBottomSheetController? _controller;
  ScrollController _scrollController = ScrollController();
  double _positionList = 0.0;

  List<Widget> _actions() {
    return [
    IconButton(
        icon: Icon(Icons.color_lens),
        padding: const EdgeInsets.only(top: 25.0, bottom: 25.0, right: 10.0),
        color: ConfigApp.of(context).color,
        onPressed: () {
          widget.showColorPicker();
        },
      ),
      Visibility(
        visible: ConfigApp.of(context).removeBackground,
        child: IconButton(
          color: ConfigApp.of(context).color,
          padding: const EdgeInsets.only(top: 25.0, bottom: 25.0, right: 10.0),
          onPressed: () {
            widget.updateImage("");
            if (_controller != null) {
              _controller!.setState!(() {
                _imageSelected = -1;
              });
            }
            ConfigApp.of(context).removeBackground = false;
          },
          icon: Icon(Icons.close)
        )
      ),
      IconButton(
        padding: const EdgeInsets.only(top: 25.0, bottom: 25.0, right: 25.0),
        onPressed: () {
          _controller = Scaffold.of(context).showBottomSheet((context) => Container(
            padding: const EdgeInsets.all(15.0),
            height: 200.0,
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
            ),
            child: NotificationListener(
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: _assetsImages.length+1,
                itemBuilder: (BuildContext context, int index) {
                  if (index <= _assetsImages.length-1) {
                    return _buildCardImage(_assetsImages[index], index); 
                  } else {
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
                          onPressed: () => Navigator.push(
                            context, MaterialPageRoute(builder: (context) => CameraPicture(
                              updateImage: widget.updateImage,
                              updateBottomSheet: () async {
                                _assetsImages = await _listAllAssetsImage();
                                _controller!.setState!(() {
                                });
                              },
                              )
                            )
                          ),
                          icon: Icon(Icons.camera, color: Colors.white, size: 40.0),
                        ),
                      ),
                    );
                  }
                }
              ),
              onNotification: (t) {
                if (t is ScrollEndNotification) {
                  _positionList = _scrollController.position.pixels;
                }

                return true;
              },
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

  Builder _iconLeading() {
    return Builder(
      builder: (BuildContext context) {
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
    );
  }

  GestureDetector _buildCardImage(String image, int index) {
    if (widget.pathImage!.isNotEmpty) {
      if (image == widget.pathImage) {
        _imageSelected = index;
      }
    }
    return GestureDetector(
      onTap: () {
        if (image != widget.pathImage) {
          widget.updateImage(image);
          _controller!.setState!(() {
            _imageSelected = index;
            _scrollController.jumpTo(_positionList);
          });
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

                      _controller!.setState!(() {
                        _imageSelected = -1;
                      });
                      
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
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        width: 120.0,
        height: 150.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: image.contains('lib') ? AssetImage(image) as ImageProvider : FileImage(File(image)),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15.0),
          border: _imageSelected == index ? Border.all(
            color: Colors.blueAccent, width: 10.0
          ) : null
        ),
      ),
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