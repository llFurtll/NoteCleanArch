import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note/data/repositories/crud_repository.dart';
import 'package:note/domain/usecases/usecases.dart';
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

  late UseCases useCases;

  @override
  void didChangeDependencies() {
    useCases = UseCases(
      repository: CrudRepository(datasourceBase: ConfigApp.of(context).datasourceBase)
    );

    super.didChangeDependencies();
  }

  PersistentBottomSheetController? _controller;
  ScrollController _scrollController = ScrollController();
  double _positionList = 0.0;

  List<Widget> _actions() {
    return [
    IconButton(
        icon: Icon(Icons.color_lens),
        padding: EdgeInsets.only(top: 25.0, bottom: 25.0, right: 10.0),
        color: ConfigApp.of(context).color,
        onPressed: () {
          widget.showColorPicker();
        },
      ),
      Visibility(
        visible: ConfigApp.of(context).removeBackground,
        child: IconButton(
          color: ConfigApp.of(context).color,
          padding: EdgeInsets.only(top: 25.0, bottom: 25.0, right: 10.0),
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
        padding: EdgeInsets.only(top: 25.0, bottom: 25.0, right: 25.0),
        onPressed: () {
          _controller = Scaffold.of(context).showBottomSheet((context) => Container(
            padding: EdgeInsets.all(15.0),
            height: 200.0,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: FutureBuilder<List<String>>(
              future: _listAllAssetsImage(),
              builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
                  default:
                  if (snapshot.hasError) {
                    return Center(child: Text("Erro ao carregar os dados"));
                  } else {
                    return NotificationListener(
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length+1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index <= snapshot.data!.length-1) {
                            return _buildCardImage(snapshot.data![index], index); 
                          } else {
                            return Container(
                              margin: EdgeInsets.only(right: 15.0),
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
                                      controller: _controller!,
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
                    );
                  }
                }
              },
            ),
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
          padding: EdgeInsets.all(25.0),
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

            Future.delayed(Duration(milliseconds: 100), () {
              _scrollController.jumpTo(_positionList);
            });
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

                      int? update = await useCases.removeBackgroundNote(image: image);
                      
                      if (update != 0) {
                        widget.updateImage("");
                        _controller!.setState!(() {
                          _imageSelected = -1;
                        });
                        ConfigApp.of(context).removeBackground = false;
                      }
                      
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
        margin: EdgeInsets.only(right: 15.0),
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