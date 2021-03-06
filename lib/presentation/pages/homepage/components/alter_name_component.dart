import 'package:flutter/material.dart';

import 'package:compmanager/core/compmanager_injector.dart';
import 'package:compmanager/domain/interfaces/icomponent.dart';

import '../../../../domain/usecases/config_user_usecases.dart';
import '../../homepage/home.dart';
import 'header_component.dart';

class AlterNameComponent implements IComponent<HomeState, Padding, void> {

  final HomeState _screen;
  final CompManagerInjector _injector = CompManagerInjector();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  
  late final ConfigUserUseCases _configUserUseCases;
  late final HeaderComponent _headerComponent;

  AlterNameComponent(this._screen) {
    init();
  }

  @override
  void afterEvent() {
    return;
  }

  @override
  void beforeEvent() {
    _name.text = _headerComponent.userName!;
  }

  @override
  Padding constructor() {
    return Padding(
      padding: MediaQuery.of(_screen.context).viewInsets,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Icon(Icons.drag_handle, color: Colors.grey, size: 40.0),
            ), 
            Container(
              margin: EdgeInsets.only(bottom: 25.0),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor escreva um nome";
                    }

                    return null;
                  },
                  autofocus: true,
                  controller: _name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: Theme.of(_screen.context).primaryColor
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: Theme.of(_screen.context).primaryColor
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              height: 50.0,
              margin: EdgeInsets.only(bottom: 25.0),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(_screen.context).primaryColor,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    int? update = await _configUserUseCases.updateName(name: _name.text);

                    if (update != 0) {
                      Navigator.of(_screen.context).pop();
                    }

                    _headerComponent.userName = _name.text;
                  }
                },
                child: Text("Salvar")
              ),
            )
          ],
        )
      ),
    );
  }

  @override
  void event() {
    beforeEvent();
    
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: _screen.context,
      builder: (BuildContext context) {
        return constructor();
      }
    );
  }

  @override
  void init() {
    _configUserUseCases = _injector.getDependencie();
    _headerComponent = _screen.getComponent(HeaderComponent) as HeaderComponent;
  }

  @override
  void dispose() {
    return;
  }
}