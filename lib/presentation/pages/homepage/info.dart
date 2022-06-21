import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Info extends StatelessWidget {

  AppBar _appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    );
  }

  CircleAvatar _avatar() {
    return CircleAvatar(
      backgroundColor: Colors.grey,
      child: CircleAvatar(
        backgroundImage: NetworkImage(
          "https://avatars.githubusercontent.com/llFurtll"
        ),
        radius: 70.0,
      ),
      radius: 75.0,
    );
  }

  IconButton _btnSocial(String url, BuildContext context, IconData icon, Color color, bool isFinal) {
    return
      IconButton(
        padding: isFinal ? EdgeInsets.only(right: 0) : EdgeInsets.only(right: 30.0),
        onPressed: () {
          _launchUrl(url, context);
        },
        icon: FaIcon(icon),
        color: color,
        iconSize: 50.0,
      );
  }

  Padding _social(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _btnSocial(
            "https://github.com/llFurtll",
            context, FontAwesomeIcons.github,
            Colors.black,
            false
          ),
          _btnSocial(
            "https://www.facebook.com/daniel.melonari/",
            context,
            FontAwesomeIcons.facebook,
            Color(0xFF3b5998),
            false
          ),
          _btnSocial(
            "https://www.linkedin.com/in/daniel-melonari/",
            context,
            FontAwesomeIcons.linkedin,
            Color(0xFF0e76a8),
            true
          )
        ],
      ),
    );
  }

  Padding _name() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Text(
          "Daniel Melonari",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25.0
          ),
        ),
    );
  }

  Padding _content() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, right: 5.0, left: 5.0),
      child: Card(
        elevation: 5.0,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Olá, obrigado por usar o Note! \n\n" +
            "Caso precise de algo, pode entrar em contato comigo por uma das " +
            "redes sociais acima, espero que goste, aceitos sugestões.\n\n" +
            "Logo abaixo também têm um botão para doações, sempre que possível estarei trazendo " +
            "atualizações para o Note, visando melhorar sua utilização, se quiser realizar uma doação " +
            "independente do valor, ficarei grato.",
            style: TextStyle(
              fontSize: 18.0,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }

  Padding _iconCoffee(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
      child: GestureDetector(
        onTap: () => _launchUrl("https://www.buymeacoffee.com/danielmelonari", context),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("lib/images/coffee.svg")
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text("Não foi possível abrir o link!"),
          action: SnackBarAction(
            label: "Fechar",
            textColor: Colors.white,
            onPressed: () {},
          ),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _avatar(),
            _social(context),
            _name(),
            _content(),
            _iconCoffee(context)
            ],
          ),
        ),
      ),
    );
  }
}