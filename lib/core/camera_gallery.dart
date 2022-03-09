import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note/domain/usecases/config_user_usecases.dart';
import 'package:path_provider/path_provider.dart';

class CameraGallery extends StatelessWidget {

  final ConfigUserUseCases? useCase;
  final Function? setState;
  final Function? updateImage;

  CameraGallery({this.useCase, this.setState, this.updateImage});

  ImagePicker imagePicker = ImagePicker();

  void _getFromGallery() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      if (useCase != null) {
        File otherPhoto = File((await useCase!.getImage()) as String);
        if (await otherPhoto.exists()) {
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
        if (await otherPhoto.exists()) {
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return createAlertDialog();
  }
}