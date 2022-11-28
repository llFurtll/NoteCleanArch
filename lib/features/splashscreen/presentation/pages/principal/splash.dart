import 'package:flutter/material.dart';

import '../../../../../core/dependencies/repository_injection.dart';
import '../../../../atualizacao/domain/entities/atualizacao.dart';
import '../../../../atualizacao/domain/usecases/atualizacao_usecase.dart';
import '../../../../atualizacao/presentation/arguments/arguments_info_atualizacao.dart';
import '../../../../atualizacao/presentation/principal/info_atualizacao.dart';
import '../../../../home/presentation/pages/principal/home_list.dart';

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

      int versao = await atualizacaoUsecase.getLastVersion();
      atualizacoes = await atualizacaoUsecase.findAllByVersaoWithoutVisualizacao(versao);
      ArgumentsInfoAtualizacao arguments = ArgumentsInfoAtualizacao(start: true, list: atualizacoes);

      Future.delayed(Duration(seconds: 3), () {
        if (atualizacoes.isNotEmpty) {
          Navigator.pushNamed(context, InfoAtualizacao.routeInfoAtualizacao, arguments: arguments);
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