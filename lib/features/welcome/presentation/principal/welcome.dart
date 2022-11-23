import 'package:flutter/material.dart';

import '../../domain/entities/atualizacao.dart';

class Welcome extends StatefulWidget {
  static final routeWelcome = "/welcome";

  final List<Atualizacao> items;

  const Welcome(this.items);

  @override
  WelcomeState createState() => WelcomeState();
}

class WelcomeState extends State<Welcome> {
  double currentPage = 0.0;
  final _pageViewController = new PageController();
  
  List<Widget> slides = [];

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
                });
              });
              return slides[index];
            }
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(top: 70.0),
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 5.0,
                children: _indicator(),
              ),
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