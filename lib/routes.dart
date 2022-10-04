import 'package:flutter/material.dart';

import 'features/note/presentation/pages/homepage/home.dart';
import 'features/note/presentation/pages/homepage/info.dart';
import 'features/note/presentation/pages/createpage/create.dart';
import 'features/note/presentation/pages/createpage/show_image_share.dart';
import 'features/note/presentation/pages/createpage/show_pdf_share.dart';

Map<String, Widget Function(BuildContext)> routes() {
  return {
    '/home': (context) => Home(),
    '/info': (context) => Info(),
    '/create': (context) => CreateNote(),
    "/share/image": (context) => ShowImageShare(),
    "/share/pdf": (context) => ShowPdfShare()
  };
}