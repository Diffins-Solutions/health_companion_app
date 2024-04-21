import 'package:flutter/foundation.dart';

class StepNotifier extends ChangeNotifier{

  int _steps = 0;

  int get steps => _steps ;

  void addSteps (int steps){
    _steps = steps;
    notifyListeners();
  }

}