import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note/data/datasources/sqlite.dart';
import 'package:note/data/repositories/crud_repository.dart';
import 'package:note/domain/usecases/usecases.dart';
import 'package:note/presentation/pages/homepage/home.dart';
import 'package:note/utils/route_animation.dart';
import 'package:note/utils/init_database.dart';
import 'package:sqflite/sqflite.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () async {
      Database _db = await initDatabase();
      SqliteDatasource _datasource = SqliteDatasource(db: _db);
      CrudRepository _repository = CrudRepository(datasourceBase: _datasource);
      UseCases _useCases = UseCases(repository: _repository);

      Navigator.of(context).pushReplacement(createRoute(Home(useCase: _useCases)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Image.asset(
          "lib/assets/logo.png",
          fit: BoxFit.fill,
          width: 250.0,
          height: 250.0,
        ),
      ),
    );
  }
}