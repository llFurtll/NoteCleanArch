import 'package:compmanager/domain/interfaces/icomponent.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/dependencies/repository_injection.dart';
import '../../../../../config_user/domain/usecases/config_user_use_case.dart';
import '../home_list.dart';
import 'header_component.dart';

class AlterNameComponent implements IComponent<HomeListState, Padding, void> {

  final HomeListState _screen;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();

  late final HeaderComponent _headerComponent;

  AlterNameComponent(this._screen) {
    init();
  }

  @override
  void bindings() {}

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
                  backgroundColor: Theme.of(_screen.context).primaryColor,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final configUserUseCase = ConfigUserUseCase(repository: RepositoryInjection.of(_screen.context)!.configUserRepository);

                    int? update = await configUserUseCase.updateName(name: _name.text);

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
    _headerComponent = _screen.getComponent(HeaderComponent) as HeaderComponent;
  }

  @override
  void dispose() {
    return;
  }

  @override
  Future<void> loadDependencies() async {}
}