import 'package:flutter/foundation.dart';

class ChangeNotifierGlobal<T> extends ChangeNotifier implements ValueListenable<T> {
  T _value;

  ChangeNotifierGlobal(this._value);

  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    notifyListeners();
  }

  @override
  T get value => _value;

  void emitChange() => notifyListeners();
}