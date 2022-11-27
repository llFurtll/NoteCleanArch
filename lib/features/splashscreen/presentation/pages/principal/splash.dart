import 'package:flutter/material.dart';

import '../../../../../core/dependencies/repository_injection.dart';
import '../../../../home/presentation/pages/principal/home_list.dart';
import '../../../../welcome/domain/entities/atualizacao.dart';
import '../../../../welcome/domain/usecases/atualizacao_usecase.dart';
import '../../../../welcome/presentation/principal/welcome.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  List<Atualizacao> atualizacoes = [];

  late final AtualizacaoUsecase atualizacaoUsecase;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      atualizacaoUsecase = AtualizacaoUsecase(RepositoryInjection.of(context)!.atualizacaoRepository);

      double versao = await atualizacaoUsecase.getLastVersion();
      atualizacoes = await atualizacaoUsecase.findAllByVersao(versao);

      Future.delayed(Duration(seconds: 3), () {
        if (atualizacoes.isNotEmpty) {
          Navigator.pushNamed(context, Welcome.routeWelcome, arguments: atualizacoes);
        } else {
          Navigator.pushNamed(context, HomeList.routeHome);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Image.asset(
          "lib/images/logo.png",
          fit: BoxFit.fill,
          width: 250.0,
          height: 250.0,
        ),
      ),
    );
  }
}