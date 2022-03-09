import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note/domain/usecases/config_user_usecases.dart';
import 'package:path_provider/path_provider.dart';

class CameraGallery extends StatelessWidget {

  final ConfigUserUseCases? useCase;
  final Function? setState;
  final Function? updateImage;
  bool removerImagem;

  CameraGallery({this.useCase, this.setState, this.updateImage, this.removerImagem = false});

  ImagePicker imagePicker = ImagePicker();

  void _getFromGallery() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      if (useCase != null) {
        File otherPhoto = File((await useCase!.getImage()) as String);
        if (otherPhoto.existsSync()) {
          otherPhoto.delete(); 
        }

        String path = (await getApplicationDocumentsDirectory()).path;
        
        final dirPerfil = Directory("$path/perfil");
        if (!dirPerfil.existsSync()) {
          dirPerfil.createSync(recursive: true);
        }

        file.saveTo("${dirPerfil.path}/${DateTime.now().toIso8601String()}.jpg");
        useCase!.updateImage(pathImage: file.path);
        setState!();
      } else {
        String path = (await getApplicationDocumentsDirectory()).path;
        String pathCompleto = "$path/${DateTime.now().toIso8601String()}.jpg";
        file.saveTo(pathCompleto);
        updateImage!(pathCompleto);
        setState!();
      }
    }
  }

  void _getFromCamera() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

    if (file != null) {
      if (useCase != null) {
        File otherPhoto = File((await useCase!.getImage()) as String);
        if (otherPhoto.existsSync()) {
          otherPhoto.delete(); 
        } 

       String path = (await getApplicationDocumentsDirectory()).path;
        
        final dirPerfil = Directory("$path/perfil");
        if (!dirPerfil.existsSync()) {
          dirPerfil.createSync(recursive: true);
        }

        file.saveTo("${dirPerfil.path}/${DateTime.now().toIso8601String()}.jpg");
        useCase!.updateImage(pathImage: file.path);
        setState!();
      } else {
        String path = (await getApplicationDocumentsDirectory()).path;
        String pathCompleto = "$path/${DateTime.now().toIso8601String()}.jpg";
        file.saveTo(pathCompleto);
        updateImage!(pathCompleto);
        setState!();
      }
    }
  }

  void _removeFoto() async {
    File photo = File((await useCase!.getImage()) as String);
    if (photo.existsSync()) {
      photo.delete(); 
    }

    useCase!.updateImage(pathImage: "");
    setState!();
  }

  Widget createAlertDialog() {
    return AlertDialog(
      title: Text("Escolha uma das opções"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => _getFromGallery(),
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
            onPressed: () => _getFromCamera(),
            child: Text(
              "Tirar foto",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black
              )
            ),
          ),
          removerImagem ? Container(height: 1.0, color: Colors.black) : Container(),
          removerImagem ?
          TextButton(
            onPressed: removerImagem ? () =>_removeFoto() : null,
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
  Widget build(BuildContext context) {
    return createAlertDialog();
  }
}