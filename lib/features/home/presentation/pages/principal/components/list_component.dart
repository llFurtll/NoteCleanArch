import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:compmanager/core/compmanager_notifier_list.dart';
import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../../../../../../../../core/notifiers/change_notifier_global.dart';
import '../../../../../../../core/widgets/animated_list.dart';
import '../../../../domain/usecases/home_use_case.dart';
import '../../../../domain/entities/home_anotacao.dart';
import '../home_list.dart';
import 'card_component.dart';

class ListComponent implements IComponent<HomeListState, Widget, void> {

  final CompManagerInjector injector = CompManagerInjector();
  final ChangeNotifierGlobal<bool> _carregandoNotifier = ChangeNotifierGlobal(true);
  final CompManagerNotifierList<Widget> _listaCardNoteNotifier = CompManagerNotifierList([]);
  final HomeListState _screen;

  late HomeUseCase _homeUseCase;

  ListComponent(this._screen) {
    init();
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
  Widget constructor() {
    return ValueListenableBuilder(
      valueListenable: _listaCardNoteNotifier,
      builder: (BuildContext context, List<Widget> value, Widget? widget) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (_carregandoNotifier.value) {
                return SizedBox(
                  height:  MediaQuery.of(context).size.height - 350,
                  child: Center(
                    child: CircularProgressIndicator()
                  ),
                );
              } else if (_listaCardNoteNotifier.value.length == 0) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SvgPicture.asset("lib/images/sem-anotacao.svg", width: 100.0, height: 100.0),
                      Text(
                        "Sem anotações!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.grey
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return _listaCardNoteNotifier.value[index];
              }
            },
            childCount: _listaCardNoteNotifier.value.length > 0 ? _listaCardNoteNotifier.value.length : 1,
          )
        );
      }
    );
  }

  @override
  void event() {
    return;
  }

  @override
  void init() async {
    _screen.addComponent(this);
    _homeUseCase = injector.getDependencie<HomeUseCase>();
    getNotes("");
  }

  @override
  void dispose() {
    return;
  }

  Future<void> getNotes(String desc) async {
    _carregandoNotifier.value = true;

    List<HomeAnotacao> _listaAnotacao = [];
    if (desc.isNotEmpty) {
      _listaAnotacao = await _homeUseCase.findWithDesc(desc: desc);
    } else {
      _listaAnotacao = await _homeUseCase.findAll();
    }

    _listaCardNoteNotifier.value.clear();

    _listaAnotacao.asMap().forEach((index, anotacao) {
      _listaCardNoteNotifier.value.add(
        Align(child: AnimatedListItem(
          index,
          CardComponent(
            _screen,
            anotacao
          ).constructor(),
        ))
      );
    });

    _carregandoNotifier.value = false;
  }

}