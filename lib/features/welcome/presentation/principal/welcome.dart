import 'package:flutter/material.dart';

import '../../../../core/dependencies/repository_injection.dart';
import '../../../../core/widgets/show_loading.dart';
import '../../../../core/widgets/show_message.dart';
import '../../../home/presentation/pages/principal/home_list.dart';
import '../../domain/entities/atualizacao.dart';
import '../../domain/usecases/atualizacao_usecase.dart';

class Welcome extends StatefulWidget {
  static final routeWelcome = "/welcome";

  final List<Atualizacao> items;

  const Welcome(this.items);

  @override
  WelcomeState createState() => WelcomeState();
}

class WelcomeState extends State<Welcome> {
  final _pageViewController = new PageController();

  late final AtualizacaoUsecase atualizacaoUsecase;
  
  List<Widget> slides = [];
  bool ultimaPagina = false;
  double currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      atualizacaoUsecase = AtualizacaoUsecase(RepositoryInjection.of(context)!.atualizacaoRepository);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (slides.isEmpty) {
      slides.addAll(getSlides());
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageViewController,
            itemCount: slides.length,
            itemBuilder: (BuildContext context, int index) {
              _pageViewController.addListener(() {
                setState(() {
                  currentPage = _pageViewController.page!;
                  ultimaPagina = currentPage == slides.length - 1;
                });
              });
              return slides[index];
            }
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(top: 70.0),
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: ultimaPagina,
                  child: ElevatedButton(
                    onPressed: () async {
                      showLoading(context);
                      double versao = widget.items[0].versao!;
                      int visualizacao = await atualizacaoUsecase.insertAtualizcao(versao);
                      if (visualizacao > 0) {
                        Navigator.of(context).pop();
                        Navigator.pushNamedAndRemoveUntil(context, HomeList.routeHome, ModalRoute.withName("/"));
                      } else {
                        Navigator.of(context).pop();
                        showMessage(context, "Ocorreu um problema no processo, tente novamente");
                      }
                    },
                    child: Text("Continuar"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                    ),
                  )
                ),
                SizedBox(height: 10.0),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 5.0,
                  children: _indicator(),
                ),
              ],
            )
          )
        ],
      ),
    );
  }

  List<Widget> getSlides() {
    return widget.items.map((item) => Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: <Widget> [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Image.asset(
              "lib/images/logo.png",
              fit: BoxFit.fitWidth,
              width: 220.0,
              alignment: Alignment.bottomCenter,
            )
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: <Widget> [
                  Text(
                    item.cabecalho!,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 2.0
                    )
                  ),
                  Text(
                    item.descricao!,
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.2,
                      fontSize: 16.0,
                      height: 1.3
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    )).toList();
  }

  List<Widget> _indicator() {
    return List<Widget>.generate(
      slides.length,
      (index) => Container(
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        height: 10.0,
        width: 10.0,
        decoration: BoxDecoration(
          color: currentPage.round() == index ? Colors.white : Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0)
        )
      ),
    );
  }
}