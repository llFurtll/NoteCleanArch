import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'config_app.dart';

class CameraPicture extends StatefulWidget {
  final Function(String pathImage) updateImage;
  final Function updateBottomSheet;

  CameraPicture({required this.updateImage, required this.updateBottomSheet});

  @override
  CameraPictureState createState() => CameraPictureState();
}

class CameraPictureState extends State<CameraPicture> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraCamera(
        onFile: (file) async {
          String path = (await getApplicationDocumentsDirectory()).path;
          File newImage = await file.copy("$path/${DateTime.now().toIso8601String()}.jpg");
          file.delete();
          widget.updateImage(newImage.path);
          widget.updateBottomSheet();
          ConfigApp.of(context).removeBackground = true;
          Navigator.of(context).pop();
        },
      )
    );
  }
}