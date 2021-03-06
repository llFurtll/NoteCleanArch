import 'dart:io';

import 'package:flutter/material.dart';

import 'package:animations/animations.dart';

import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/core/conversable.dart';

import '../../../components/show_message.dart';
import '../home.dart';
import '../../../../domain/usecases/crud_usecases.dart';
import '../../createpage/create.dart';
import '../../../../data/model/anotacao_model.dart';
import 'header_component.dart';
import '../../../../core/change_notifier_global.dart';

class CardComponent extends IComponent<HomeState, ValueListenableBuilder, void> {

  final CompManagerInjector _injector = CompManagerInjector();
  final Conversable _conversable = Conversable();
  final HomeState _screen;
  final AnotacaoModel _anotacao;
  final ChangeNotifierGlobal<double> _offset = ChangeNotifierGlobal(0.0);

  late final CrudUseCases _useCases;
  late final HeaderComponent _headerComponent;

  bool _visibilityButtons = false;
  double _opacity = 0.0;

  CardComponent(this._screen, this._anotacao) {
    init();
  }

  final Map _months = {
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

  @override
  void afterEvent() {
    return;
  }

  @override
  void beforeEvent() {
    return;
  }

  @override
  ValueListenableBuilder<double> constructor() {
    return ValueListenableBuilder(
      valueListenable: _offset,
      builder: (BuildContext context, double value, Widget? widget) {
        return Stack(
          children: [
            _buttonsActions(),
            _card()
          ]
        );
      },
    );
  }

  @override
  void event() {
    return;
  }

  @override
  void init() {
    _useCases = _injector.getDependencie();
    _headerComponent = _screen.getComponent(HeaderComponent) as HeaderComponent;
  }

  @override
  void dispose() {
    return;
  }

  Positioned _buttonsActions() {
    return Positioned(
      right: 0.0,
      top: 0.0,
      child: Opacity(
        opacity: _opacity,
        child: Visibility(
        visible: _visibilityButtons,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Transform.scale(
              scale: _opacity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: CircleBorder()
                ),
                child: const Icon(Icons.delete, color: Colors.white),
                onPressed: _removeNote
              ),
            ),
            // Transform.scale(
            //   scale: _opacity.value,
            //   child: TextButton(
            //     style: TextButton.styleFrom(
            //       backgroundColor: Colors.green,
            //       shape: const CircleBorder()
            //     ),
            //     child: Icon(Icons.check, color: Colors.white),
            //     onPressed: _updateSituacao,
            //   ),
            // ),
          ]
          ),
        ),
      ),
    );
  }

  Container _card() {
    return Container(
      width: MediaQuery.of(_screen.context).size.width * 0.9,
      child: ValueListenableBuilder(
        valueListenable: _offset,
        builder: (BuildContext context, double value, Widget? widget) {
          return GestureDetector(
            onTap: null,
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx < 0) {
                if (_offset.value > -60.0) {
                  _offset.value -= -details.delta.dx;
                  _visibilityButtons = true;
                  _opacity = _offset.value.abs() / 60.0;
                  if (_opacity > 1.0) {
                    _opacity = 1.0;
                  }
                  if (_offset.value < -60.0) {
                    _offset.value = -60.0;
                  }
                }
              } else {
                if (_offset.value < 0.0) {
                  _offset.value += details.delta.dx;
                  _opacity = _offset.value.abs() / 60.0;
                  if (_opacity > 1.0) {
                    _opacity = 1.0;
                  }
                  if (_offset.value > 0.0) {
                    _offset.value = 0.0;
                    _visibilityButtons = false;
                  }
                }
              }
            },
            child: Transform.translate(
              offset: Offset(_offset.value, 0.0),
              child: OpenContainer(
                transitionDuration: Duration(milliseconds: 500),
                transitionType: ContainerTransitionType.fade,
                closedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                middleColor: Colors.red,
                openElevation: 0.0,
                closedElevation: 0.0,
                closedColor: Colors.transparent,
                openBuilder: (BuildContext context, VoidCallback _) {
                  _headerComponent.removeFocusNode();
                  return CreateNote(id: _anotacao.id!);
                },
                closedBuilder: (BuildContext context, VoidCallback _) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    color: Theme.of(context).cardColor,
                    elevation: 10.0,
                    shadowColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      decoration: _anotacao.imagemFundo!.isEmpty ? null : BoxDecoration(
                        image: DecorationImage(
                          image: _anotacao.imagemFundo!.contains("lib") ?
                            AssetImage(_anotacao.imagemFundo!) as ImageProvider :
                            FileImage(File(_anotacao.imagemFundo!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: _anotacao.imagemFundo!.isEmpty ? null : BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: _contentCard(),
                        ),
                      ),
                    ),
                  );
                },
              ) 
            ),
          );
        },
      ),
    );
  }

  void _removeNote() async {
    int? delete = await _useCases.deleteUseCase(id: _anotacao.id!);
    
    if (delete == 1) {
      MessageDefaultSystem.showMessage(
        _screen.context,
        "Anotacão deletada com sucesso!"
      );

      _conversable.callScreen("home")!.receive("refresh", "");
    }
  }

  // void _updateSituacao() async {
  //   int? update = await useCases.updateSituacaoUseCase(anotacao: _anotacao);
    
  //   if (update != 0) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Theme.of(context).primaryColor,
  //         content: Text("Anotacão finalizada com sucesso!"),
  //         action: SnackBarAction(
  //           label: "Fechar",
  //           textColor: Colors.white,
  //           onPressed: () {},
  //         ),
  //       ),
  //     );

  //     widget.setState();
  //   }
  // }

  Column _contentCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            _anotacao.titulo!,
            style: TextStyle(
              color: _anotacao.cor!.isNotEmpty ? Color(int.parse("${_anotacao.cor}")) : Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child:  Text(
            _anotacao.observacao!,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(
              color: _anotacao.cor!.isNotEmpty ? Color(int.parse("${_anotacao.cor}")) : Colors.black,
              fontSize: 15.0,
              fontWeight: FontWeight.normal
            ),
          ),
        ),
        Text(
          _formatDate(_anotacao.data!),
          style: TextStyle(
            color: _anotacao.cor!.isNotEmpty ? Color(int.parse("${_anotacao.cor}")) : Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.normal
          ),
        ),
      ],
    );
  }
}