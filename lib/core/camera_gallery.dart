import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note/domain/usecases/config_user_usecases.dart';
import 'package:path_provider/path_provider.dart';

class CameraGallery extends StatelessWidget {

  final ConfigUserUseCases useCase;
  final Function setState;

  CameraGallery({required this.useCase, required this.setState});

  ImagePicker imagePicker = ImagePicker();

  void _getFromGallery() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
  }

  void _getFromCamera() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

    if (file != null) {
      String path = (await getApplicationDocumentsDirectory()).path;
      file.saveTo("$path/${DateTime.now().toIso8601String()}.jpg");
      useCase.updateImage(pathImage: file.path);
      setState();
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