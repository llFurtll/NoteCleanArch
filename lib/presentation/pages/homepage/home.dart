import 'package:flutter/material.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/data/repositories/crud_repository.dart';
import 'package:note/domain/usecases/usecases.dart';
import 'package:note/presentation/pages/createpage/config_app.dart';
import 'package:note/presentation/pages/createpage/create.dart';
import 'package:note/presentation/pages/homepage/card.dart';
import 'package:note/utils/route_animation.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {

  late UseCases useCases;

  @override
  void didChangeDependencies() {
    useCases = UseCases(
      repository: CrudRepository(datasourceBase: ConfigApp.of(context).datasourceBase)
    );

    super.didChangeDependencies();
  }

  Future<List<Widget>> _getNotes() async {
    List<AnotacaoModel?> _listaAnotacao = await useCases.findAlluseCase();
    
    List<Widget> _listaNote = [];

    _listaAnotacao.forEach((anotacao) {
      _listaNote.add(
        CardNote(
          anotacaoModel: anotacao!,
          setState: () {
            setState(() {});
          },
        ),
      );
    });

    return _listaNote;
  }

  Widget _top() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.white,
      expandedHeight: 250.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.yellow,
                      radius: 35.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text("Daniel Melonari",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Pesquisar anotação",
                        suffixIcon: Icon(Icons.search, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Colors.white
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white
                          )
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white
                          )
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white54
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0)),
            color: Theme.of(context).primaryColor
          ),
        ),
      ),
    );
  }

  Widget _home() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget> [
          _top()
        ];
      },
      body: FutureBuilder(
        future: _getNotes(),
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
            default:
            if (snapshot.hasError) {
              return Center(child: Text("Erro ao carregar os dados"));
            } else {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text("Sem anotações!"),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Align(child: AnimatedListItem(index, snapshot.data![index]));
                  },
                );
              }
            }
          }
        },
      ),
    );
  }

  FloatingActionButton _button() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      onPressed: () => Navigator.of(context).push(
        createRoute(
          CreateNote(
            setState: () {
              setState(() {});
            },
          )
        )
      ),
      child: Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _home(),
      floatingActionButton: _button(),
    );
  }
}

class AnimatedListItem extends StatefulWidget {
  final int index;
  final Widget child;

  AnimatedListItem(this.index, this.child, {Key? key}) : super(key: key);

  @override
  _AnimatedListItemState createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem> {
  bool _animate = false;

  static bool _isStart = true;

  @override
  void initState() {
    super.initState();
    _isStart
        ? Future.delayed(Duration(milliseconds: widget.index * 100), () {
            setState(() {
              _animate = true;
              _isStart = false;
            });
          })
        : _animate = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      opacity: _animate ? 1 : 0,
      curve: Curves.easeInOutQuart,
      child: AnimatedPadding(
        duration: Duration(milliseconds: 1000),
        padding: _animate
            ? const EdgeInsets.all(4.0)
            : const EdgeInsets.only(top: 10),
        child: Container(
          child: widget.child
        ),
      ),
    );
  }
}