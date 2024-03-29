import 'package:flutter/material.dart';

import 'core/databases/init_database.dart';
import 'core/dependencies/repository_injection.dart';
import 'features/atualizacao/data/datasources/atualizacao_datasource.dart';
import 'features/atualizacao/data/repositories/atualizacao_repository_impl.dart';
import 'features/config_app/data/datasources/config_app_datasource.dart';
import 'features/config_app/data/repositories/config_app_repository_impl.dart';
import 'features/config_user/data/datasources/config_user_datasource.dart';
import 'features/config_user/data/repositories/config_user_repository_impl.dart';
import 'features/home/data/datasources/home_datasource.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/note/data/datasources/note_datasource.dart';
import 'features/note/data/repositories/note_repository_impl.dart';
import 'features/splashscreen/presentation/pages/principal/splash.dart';
import 'features/versao/data/datasources/versao_datasource.dart';
import 'features/versao/data/repositories/versao_repository_impl.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDatabase();
  
  runApp(
    RepositoryInjection(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Application(),
        theme: ThemeData(
          primaryColor: Color(0xFFA50044),
          scaffoldBackgroundColor: Colors.white,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(0XFFA50044)
          ),
          cardColor: Color(0XFFFFFFFF),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Color(0XFFA50044)
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFA50044)),
          progressIndicatorTheme: ProgressIndicatorThemeData(
            color: Color(0xFFA50044),
            circularTrackColor: Colors.white
          ),
        ),
        routes: routes(),
      ),
      configAppRepository: ConfigAppRepositoryImpl(dataSource: ConfigAppDataSourceImpl()),
      configUserRepository: ConfigUserRepositoryImpl(dataSource: ConfigUserDataSourceImpl()),
      homeRepository: HomeRepositoryImpl(dataSource: HomeDataSourceImpl()),
      noteRepository: NoteRepositoryImpl(datasourceBase: NoteDataSourceImpl()),
      atualizacaoRepository: AtualizacaoRepositoryImpl(dataSource: AtualizacaoDataSourceImpl()),
      versaoRepository: VersaoRepositoryImpl(dataSource: VersaoDataSourceImpl()),
    )
  );
}

class Application extends StatefulWidget {
  @override
  ApplicationState createState() => ApplicationState();
}

class ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(),
    );
  }
}