import 'package:flutter/material.dart';

import './presentation/pages/homepage/home.dart';
import './presentation/pages/homepage/info.dart';
import './presentation/pages/createpage/create.dart';

Map<String, Widget Function(BuildContext)> routes() {
  return {
    '/home': (context) => Home(),
    '/info': (context) => Info(),
    '/create': (context) => CreateNote()
  };
}