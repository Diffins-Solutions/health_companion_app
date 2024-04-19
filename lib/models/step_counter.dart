import 'dart:async';

import 'package:health_companion_app/contollers/daily_target_controller.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepCounter {
  final double _zThreshold;
  final double _xyThreshold;
  StreamSubscription<AccelerometerEvent>? _streamSubscription;
  double _previousZ = 0.0; // Added for peak detection

  StepCounter({double zThreshold = 2.0, double xyThreshold = 0.5})
      : _zThreshold = zThreshold,
        _xyThreshold = xyThreshold;


  Future<void> startListening() async {
    if (_streamSubscription == null) {
      _streamSubscription = accelerometerEvents.listen(_onAccelerometerData);
    }
  }

  void stopListening() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  bool _isPeak(double value) {
    // Simple peak detection based on change in Z-axis
    bool isPeak = value.abs() > _zThreshold && value * _previousZ < 0;
    _previousZ = value; // Update for next peak detection
    return isPeak;
  }

  void _onAccelerometerData(AccelerometerEvent event) async {
    double currentZ = event.z;
    double currentX = event.x.abs();
    double currentY = event.y.abs();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int stepCount = prefs.getInt('counter')!;
    if (_isPeak(currentZ)) {
      if (currentX > _xyThreshold || currentY > _xyThreshold) {
        checkDateAndUpdate(prefs.getString('yesterday')!).then((reset)async {
          print('Reset $reset');
          if(!reset){
            await prefs.setInt('counterP', stepCount);
            stepCount++;
            await prefs.setInt('counter', stepCount);
          }
        });

      }
    }
    //print("Step count: $stepCount");
  }

  Future checkDateAndUpdate(String date) async {
    try{
      DateTime prefsToday = DateTime.parse(date);
      DateTime today = DateTime.now();
     if(today.difference(prefsToday).inDays != 0){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Future result = await DailyTargetController.addOrUpdateSteps(DateFormat.yMMMMd().format(prefsToday), prefs.getInt('counter')!);
        await prefs.setInt('counter', 0);
        await prefs.setInt('counterP', 0);
        await prefs.setString('today', today.toString());
        await prefs.setString('yesterday', prefsToday.toString());
        return Future(() => true);
      }
      return Future(() => false);
    }catch (e){
      rethrow;
    }
  }

  Future isMoving () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int stepCount = prefs.getInt('counter')!;
    int stepCountP = prefs.getInt('counterP')!;
    return Future(() => stepCount != stepCountP);
  }

}