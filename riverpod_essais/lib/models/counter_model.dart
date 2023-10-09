import 'dart:async';

import 'package:flutter/material.dart';

///
/// Création du modèle de données pour les compteurs
///
class CounterModel extends ChangeNotifier {
  int _counter = 0;
  late Timer refreshScreenTimer;

  CounterModel({int? counter}) {
    if (counter != null) {
      _counter = counter;
    }

    refreshScreenTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      incrementCounter();
      if (_counter > 10) {
        this.counter = -9;
      }
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    refreshScreenTimer.cancel();
    super.dispose();
  }

  int get counter => _counter;

  set counter(int value) {
    _counter = value;
    notifyListeners();
    debugPrint("set new counter value = $_counter");
  }

  void incrementCounter() {
    _counter++;
    notifyListeners();
    debugPrint("increment counter = $_counter");
  }

  void decrementCounter() {
    _counter--;
    notifyListeners();
    debugPrint("decrement counter = $_counter");
  }

  void resetCounter() {
    _counter = 0;
    notifyListeners();
    debugPrint("reset counter = $_counter");
  }

}
