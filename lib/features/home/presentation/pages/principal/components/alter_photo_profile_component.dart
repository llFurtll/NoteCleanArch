import 'dart:io';

import 'package:flutter/material.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/dependencies/repository_injection.dart';
import '../../../../../config_user/domain/usecases/config_user_use_case.dart';
import '../home_list.dart';
import '../components/header_component.dart';

class AlterPhotoProfileComponent implements IComponent<HomeListState, AlertDialog, Future<bool>> {

  final  ImagePicker _imagePicker = ImagePicker();
  final HomeListState _screen;

  late final HeaderComponent _headerComponent;

  bool _removeOptionImage = true;

  AlterPhotoProfileComponent(this._screen) {
    init();
  }

  @override
  Future<bool> afterEvent() async {
    Navigator.of(_screen.context).pop();

    return true;
  }

  @override
  Future<bool> beforeEvent() async {
    _removeOptionImage = _headerComponent.imagePath!.isNotEmpty;
    return true;
  }

  @override
  AlertDialog constructor() {
    return AlertDialog(
      title: Text("Escolha uma das opções"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () async {
              _getFromGallery();
              await afterEvent();
            },
            child: Text(
              "Abrir da galeria",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black
              )
            ),
          ),
          Container(height: 1.0, color: Colors.black),
          TextButton(
            onPressed: () async {
              _getFromCamera();
              await afterEvent();
            },
            child: Text(
              "Tirar foto",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black
              )
            ),
          ),
          _removeOptionImage ? Container(height: 1.0, color: Colors.black) : Container(),
          _removeOptionImage ?
          TextButton(
            onPressed: _removeOptionImage ? () async {
              _removeFoto();
              await afterEvent();
            } : null,
            child: Text(
              "Remover foto",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black
              )
            ),
          ) : Container()
        ],
      ),
    );
  }

  @override
  void dispose() {
    return;
  }

  @override
  Future<bool> event() async {
    await beforeEvent();

    showDialog<bool>(
      context: _screen.context,
      builder: (BuildContext context) {
        return constructor();
      }
    );

    return true;
  }

  @override
  void init() {
    _headerComponent = _screen.getComponent(HeaderComponent) as HeaderComponent;
  }

  void _getFromGallery() async {
    XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final configUserUseCase = ConfigUserUseCase(repository: RepositoryInjection.of(_screen.context)!.configUserRepository);

      String? pathOtherImage = await configUserUseCase.getImage();
      File otherPhoto = File(pathOtherImage!);

      if (otherPhoto.existsSync()) {
        otherPhoto.delete(); 
      }

      String path = (await getApplicationDocumentsDirectory()).path;
      
      final dirPerfil = Directory("$path/perfil");

      if (!dirPerfil.existsSync()) {
        dirPerfil.createSync(recursive: true);
      }

      file.saveTo("${dirPerfil.path}/${DateTime.now().toIso8601String()}.jpg");

      configUserUseCase.updateImage(pathImage: file.path);

      _headerComponent.imagePath = file.path;
    }
  }

  void _getFromCamera() async {
    XFile? file = await _imagePicker.pickImage(source: ImageSource.camera);

    if (file != null) {
      final configUserUseCase = ConfigUserUseCase(repository: RepositoryInjection.of(_screen.context)!.configUserRepository);

      String? pathOtherImage = await configUserUseCase.getImage();
      File otherPhoto = File(pathOtherImage!);

      if (otherPhoto.existsSync()) {
        otherPhoto.delete(); 
      } 

      String path = (await getApplicationDocumentsDirectory()).path;
      
      final dirPerfil = Directory("$path/perfil");

      if (!dirPerfil.existsSync()) {
        dirPerfil.createSync(recursive: true);
      }

      file.saveTo("${dirPerfil.path}/${DateTime.now().toIso8601String()}.jpg");

      configUserUseCase.updateImage(pathImage: file.path);

      _headerComponent.imagePath = file.path;
    }
  }

  void _removeFoto() async {
    final configUserUseCase = ConfigUserUseCase(repository: RepositoryInjection.of(_screen.context)!.configUserRepository);

    String? pathPhoto = await configUserUseCase.getImage();
    File photo = File(pathPhoto!);

    if (photo.existsSync()) {
      photo.delete(); 
    }

    configUserUseCase.updateImage(pathImage: "");

    _headerComponent.imagePath = "";
  }
  
}