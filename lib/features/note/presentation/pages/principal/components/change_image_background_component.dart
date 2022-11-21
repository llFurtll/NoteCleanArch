import 'dart:convert';
import 'dart:io';

import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../../../core/notifiers/change_notifier_global.dart';
import '../../../../../../core/dependencies/repository_injection.dart';
import '../../../../../../core/utils/format_date.dart';
import '../../../../../config_app/domain/usecases/config_app_use_case.dart';
import '../../../../domain/usecases/note_usecase.dart';
import '../create.dart';
import 'app_bar_create_component.dart';

class ChangeImageBackgroundComponent implements IComponent<CreateNoteState, Container, Future<bool>> {

  final CreateNoteState _screen;
  final _imageSelected = ChangeNotifierGlobal<int>(-1);
  final ImagePicker _imagePicker = ImagePicker();
  final ChangeNotifierGlobal<List<Widget>> _assetsImages = ChangeNotifierGlobal([]);

  late final AppBarCreateComponent _appBarCreateComponent;
  late final NoteUseCase _noteUseCase;
  late final ConfigAppUseCase _configAppUseCase;
  late final Map<String?, int?> _configsApp;

  ChangeImageBackgroundComponent(this._screen) {
    init();
  }

  @override
  void bindings() {
    _noteUseCase = NoteUseCase(repository: RepositoryInjection.of(_screen.context)!.noteRepository);
    _configAppUseCase = ConfigAppUseCase(repository: RepositoryInjection.of(_screen.context)!.configAppRepository);
  }

  @override
  Future<bool> afterEvent() async {
    Navigator.of(_screen.context).pop();

    return true;
  }

  @override
  Future<bool> beforeEvent() async {
    return true;
  }

  @override
  Container constructor() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      height: 200.0,
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ValueListenableBuilder(
          valueListenable: _assetsImages,
          builder: (BuildContext context, List<Widget> value, Widget? widget) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: _assetsImages.value,
            );
          },
        ),
      )
    );
  }

  @override
  Future<bool> event() async {
    await _loadImages();

    showModalBottomSheet(
      context: _screen.context,
      builder: (BuildContext context) {
        return constructor();
      }
    );
    
    return true;
  }

  @override
  void init() {
    _appBarCreateComponent = _screen.getComponent(AppBarCreateComponent) as AppBarCreateComponent;
  }

  @override
  void dispose() {
    return;
  }

  @override
  Future<void> loadDependencies() async {
    _configsApp = await _configAppUseCase.getAllConfigs(modulo: "APP");
  }

  set imageSelected(int selected) {
    _imageSelected.value = selected;
  }

  Future<void> _loadImages() async {
    _assetsImages.value.clear();
    _assetsImages.value.addAll(_returnCardsImage(await _listAllAssetsImage()));
    _assetsImages.emitChange();
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

    assetImages.sort(((b, a) => a.compareTo(b)));
    
    assetImages.addAll(
      manifestMap.keys
      .where((String key) => key.contains('lib/images/'))
      .where((String key) => key.contains('.jpg'))
      .toList()
    );
    
    return assetImages;
  }

  List<Widget> _returnCardsImage(List<String> pathImages) {
    List<Widget> lista = [];
    pathImages.asMap().forEach((index, element) {
      Image image;
      if (element.contains("lib")) {
        image = Image.asset(element);
        precacheImage(image.image, _screen.context);
        lista.add(_buildCardImage(image, element, index));
      } else {
        image = Image.file(File(element));
        precacheImage(image.image, _screen.context);
        lista.add(_buildCardImage(image, element, index));
      }
    });

    lista.add(_addPhoto());

    return lista;
  }

  GestureDetector _buildCardImage(Image image, String pathImage, int index) {
    if (_screen.pathImage.isNotEmpty) {
      if (pathImage == _screen.pathImage) {
        _imageSelected.value = index;
      }
    }

    return GestureDetector(
      onTap: () {
        if (pathImage != _screen.pathImage) {
          _screen.pathImage = pathImage;
          _imageSelected.value = index;
          _appBarCreateComponent.removeBackground = true;
          _appBarCreateComponent.changeMenuItens();

          print(_configsApp);

          if (_configsApp["AUTOSAVE"] == 1) {
            _appBarCreateComponent.emitComponentAutoSave();
          }

        }
      },
      onLongPress: () {
        if (!pathImage.contains('lib')) {
          _showDialogDeletePhoto(pathImage);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        width: 120.0,
        height: 150.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: image.image,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ValueListenableBuilder(
          valueListenable: _imageSelected,
          builder: (BuildContext context, int value, Widget? widget) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15.0),
                border: _imageSelected.value == index ? Border.all(
                  color: Colors.blueAccent, width: 10.0
                ) : null
              ),
            );
          },
        ),
      ),
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
          onPressed: _showDialogPhoto,
          icon: Icon(Icons.camera, color: Colors.white, size: 40.0),
        ),
      ),
    );
  }

  void _showDialogPhoto() {
    showDialog(
      barrierDismissible: false,
      context: _screen.context,
      builder: (BuildContext context) {
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
              )
            ],
          ),
        );
      }
    );
  }

  void _showDialogDeletePhoto(String pathImage) {
    showDialog(
      context: _screen.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Deletar imagem?", style: TextStyle(color: Colors.black)),
          content: Text("Ao deletar a imagem, automaticamente a foto será removido do aplicativo e será atualizado a anotação!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Não",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              )
            ),
            TextButton(
              onPressed: () async {
                File(pathImage).delete();

                _appBarCreateComponent.changeEstaSalvando(true);
                _appBarCreateComponent.changeTitle("Salvando...");

                int? update = await _noteUseCase.removeBackgroundNote(image: pathImage);
                
                await _loadImages();

                _appBarCreateComponent.removeBackground = false;
                _appBarCreateComponent.changeMenuItens();

                _appBarCreateComponent.changeEstaSalvando(false);
                _appBarCreateComponent.changeTitle("Salvo em: ${formatDate(_screen.note.ultimaAtualizacao!, false, true)}");
                
                if (update != 0) {
                  _screen.pathImage = "";
                }

                if (update == 0 && !pathImage.contains('lib')) {
                  _screen.pathImage = "";
                }

                _imageSelected.value = -1;
                
                Navigator.of(context).pop();
              },
              child: Text(
                "Sim",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              )
            )
          ],
        );
      }
    );
  }

  void _getFromGallery() async {
    XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      String path = (await getApplicationDocumentsDirectory()).path;

      String pathCompleto = "$path/${DateTime.now().toIso8601String()}.jpg";

      file.saveTo(pathCompleto);

      _screen.pathImage = pathCompleto;
      
      await _loadImages();

      _appBarCreateComponent.removeBackground = true;
    }
  }

  void _getFromCamera() async {
    XFile? file = await _imagePicker.pickImage(source: ImageSource.camera);

    if (file != null) {
      String path = (await getApplicationDocumentsDirectory()).path;

      String pathCompleto = "$path/${DateTime.now().toIso8601String()}.jpg";

      file.saveTo(pathCompleto);

      _screen.pathImage = pathCompleto;

      await _loadImages();

      _appBarCreateComponent.removeBackground = true;
    }
  }
}