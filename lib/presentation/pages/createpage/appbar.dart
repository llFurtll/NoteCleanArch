import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note/presentation/pages/createpage/create.dart';

class AppBarCreate extends StatefulWidget {
  final Function(String pathImage) updateImage;

  AppBarCreate({required this.updateImage});

  @override
  AppBarCreateState createState() => AppBarCreateState();
}

class AppBarCreateState extends State<AppBarCreate> {

  final GlobalKey<CreateNoteState> _creaKey = GlobalKey();

  List<Widget> _actions() {
    return [
      IconButton(
        splashColor: Color(0xFF004D98),
        padding: EdgeInsets.all(25.0),
        onPressed: () {
          Scaffold.of(context).showBottomSheet((context) => Container(
            padding: EdgeInsets.all(15.0),
            height: 200.0,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: FutureBuilder<List<String>>(
              future: listAllAssetsImage(),
              builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
                  default:
                  if (snapshot.hasError) {
                    return Center(child: Text("Erro ao carregar os dados"));
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildCardImage(snapshot.data![index]);  
                      }
                    );
                  }
                }
              },
            ),
          ));
        },
        icon: Icon(
          Icons.photo,
          color: Theme.of(context).appBarTheme.titleTextStyle!.color,
        ),
      ),
    ];
  }

  Future<List<String>> listAllAssetsImage() async {
    List<String> assetImages;

    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    
    assetImages = manifestMap.keys
      .where((String key) => key.contains('lib/images/'))
      .where((String key) => key.contains('.jpg'))
      .toList();

    return assetImages;
  }

  Builder _iconLeading() {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
            splashColor:  Color(0xFF004D98),
            padding: EdgeInsets.all(25.0),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).appBarTheme.titleTextStyle!.color
            ),
            onPressed: () => Navigator.pop(context),
          );
      }
    );
  }

  GestureDetector buildCardImage(String image) {
    return GestureDetector(
      onTap: () {
        widget.updateImage(image);
      },
      child: Container(
        margin: EdgeInsets.only(right: 15.0),
        width: 120.0,
        height: 150.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15.0)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      actions: _actions(),
      leading: _iconLeading(),
    );
  }
}