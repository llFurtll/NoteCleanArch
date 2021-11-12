import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note/data/datasources/get_connection.dart';
import 'package:note/data/model/anotacao_model.dart';
import 'package:note/domain/usecases/usecases.dart';
import 'package:note/presentation/pages/createpage/create.dart';
import 'package:note/utils/route_animation.dart';

class CardNote extends StatefulWidget {
  final AnotacaoModel anotacaoModel;
  final Function setState;

  CardNote({
      required this.anotacaoModel,
      required this.setState
  });
  
  @override
  CardNoteState createState() => CardNoteState();
}

class CardNoteState extends State<CardNote> {

  bool _visibilityButtons = false;
  double _offset = 0.0;
  double _opacity = 0.0;

  Map _months = {
    1: "janeiro",
    2: "fevereiro",
    3: "março",
    4: "abril",
    5: "maio",
    6: "junho",
    7: "julho",
    8: "agosto",
    9: "setembro",
    10: "outubro",
    11: "novembro",
    12: "dezembro"
  };
  
  String _formatDate(String data) {
    DateTime date = DateTime.parse(data);

    return "${date.day.toString().padLeft(2,'0')} de ${_months[date.month]} de ${date.year}";
  }

  Column _contentCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 5.0),
          child: Text(
            widget.anotacaoModel.titulo!,
            style: TextStyle(
              color: widget.anotacaoModel.cor!.isNotEmpty ? Color(int.parse("0xFF${widget.anotacaoModel.cor}")) : Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5.0),
          child:  Text(
            widget.anotacaoModel.observacao!,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(
              color: widget.anotacaoModel.cor!.isNotEmpty ? Color(int.parse("0xFF${widget.anotacaoModel.cor}")) : Colors.black,
              fontSize: 15.0
            ),
          ),
        ),
        Text(
          _formatDate(widget.anotacaoModel.data!),
          style: TextStyle(
            color: widget.anotacaoModel.cor!.isNotEmpty ? Color(int.parse("0xFF${widget.anotacaoModel.cor}")) : Colors.black,
            fontSize: 14.0
          ),
        ),
      ],
    );
  }

  Container _card() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            createRoute(
              CreateNote(
                setState: widget.setState,
                id: widget.anotacaoModel.id!,
              )
            )
          );
        },
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx < 0) {
            setState(() {
              if (_offset > -60.0) {
                _offset -= -details.delta.dx;
                _visibilityButtons = true;
                _opacity = _offset.abs() / 60.0;
                if (_opacity > 1.0) {
                  _opacity = 1.0;
                }
                if (_offset < -60.0) {
                  _offset = -60.0;
                }
              }
            });
          } else {
            setState(() {
              if (_offset < 0.0) {
                _offset += details.delta.dx;
                _opacity = _offset.abs() / 60.0;
                if (_opacity > 1.0) {
                  _opacity = 1.0;
                }
                if (_offset > 0.0) {
                  _offset = 0.0;
                  _visibilityButtons = false;
                }
              }
            });
          }
        },
        child: Transform.translate(
          offset: Offset(_offset, 0.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            color: Theme.of(context).cardColor,
            elevation: 10.0,
            shadowColor: Theme.of(context).scaffoldBackgroundColor,
            child: Container(
              decoration: widget.anotacaoModel.imagemFundo!.isEmpty ? null : BoxDecoration(
                image: DecorationImage(
                  image: widget.anotacaoModel.imagemFundo!.contains("lib") ?
                    AssetImage(widget.anotacaoModel.imagemFundo!) as ImageProvider :
                    FileImage(File(widget.anotacaoModel.imagemFundo!)),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: widget.anotacaoModel.imagemFundo!.isEmpty ? null : BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.white.withOpacity(0.5),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: _contentCard(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Positioned _buttonsActions() {
    return Positioned(
      right: 0.0,
      top: 0.0,
      child: Opacity(
        opacity: _opacity,
        child: Visibility(
        visible: _visibilityButtons,
        child:  Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: _opacity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: CircleBorder()
                  ),
                  child: Icon(Icons.delete, color: Colors.white),
                  onPressed: _removeNote
                ),
              ),
              Transform.scale(
                scale: _opacity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: CircleBorder()
                  ),
                  child: Icon(Icons.check, color: Colors.white),
                  onPressed: _updateSituacao,
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }

  Stack _cardWithButtons() {
    return Stack(
      children: [
        _buttonsActions(),
        _card()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _cardWithButtons();
  }

  void _removeNote() async {
    UseCases useCase = await GetConnectionDataSource.getConnection();
    int? delete = await useCase.deleteUseCase(id: widget.anotacaoModel.id!);
    GetConnectionDataSource.closeConnection();
    
    if (delete == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text("Anotacão deletada com sucesso!"),
          action: SnackBarAction(
            label: "Fechar",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );

      widget.setState();
    }
  }

  void _updateSituacao() async {
    UseCases useCase = await GetConnectionDataSource.getConnection();
    int? update = await useCase.updateSituacaoUseCase(anotacao: widget.anotacaoModel);
    GetConnectionDataSource.closeConnection();
    
    if (update != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text("Anotacão finalizada com sucesso!"),
          action: SnackBarAction(
            label: "Fechar",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );

      widget.setState();
    }
  }
}