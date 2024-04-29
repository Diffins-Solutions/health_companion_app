import 'dart:async';
import 'dart:math';
import 'package:health_companion_app/contollers/daily_target_controller.dart';
import 'package:health_companion_app/models/steps_notifer.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepCounter {

  final double _zThreshold;
  final double _xyzThreshold;
  int i = 0;
  StreamSubscription<AccelerometerEvent>? _streamSubscription;
  double _previousX = 0.0;
  double _previousY = 0.0;
  double _previousZ = 0.0; // Added for peak detection
  final StepNotifier provider;



  StepCounter({required this.provider, double zThreshold = 1.0, double xyzThreshold = 0.8})
      : _zThreshold = zThreshold,
        _xyzThreshold = xyzThreshold;

  Future<void> startListening() async {
    if (_streamSubscription == null) {
      _streamSubscription = Stream.periodic(Duration(milliseconds: 600)).asyncMap((_) => accelerometerEvents.first).listen(_onAccelerometerData);
    }
  }

  void stopListening() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  // bool _isPeak(double X, double Y, double Z) {
  //   //print('prev x,y,z: $_previousX, $_previousY, $_previousZ');
  //   //print('x,y,z : $X, $Y, $Z');
  //   // Simple peak detection based on change in Z-axis
  //   double prevAbsXYZ = sqrt(_previousX*_previousX + _previousY*_previousY + _previousZ*_previousZ);
  //   //print('Prev abs $prevAbsXYZ');
  //   double absXYZ =sqrt( X*X + Y*Y + Z*Z);
  //   //print('Abs: $absXYZ');
  //   double value = prevAbsXYZ - absXYZ;
  //   bool isPeak = value.abs() > _xyzThreshold && Z > 9.36;
  //   if(isPeak){
  //     print('is Step : $isPeak');
  //   }
  //   _previousX = X;
  //   _previousY = Y;
  //   _previousZ = Z; // Update for next peak detection
  //   return isPeak;
  // }

  bool _isPeak(double X, double Y, double Z) {
    // Low-pass filter to reduce noise
    double alpha = 0.8;
    // X = alpha * _previousX + (1 - alpha) * X;
    // Y = alpha * _previousY + (1 - alpha) * Y;
    // Z = alpha * _previousZ + (1 - alpha) * Z;

    double prevAbsXYZ = sqrt(_previousX*_previousX + _previousY*_previousY + _previousZ*_previousZ);
    double absXYZ = sqrt(X*X + Y*Y + Z*Z);

    // if(X - Z > 1.5 && Y - Z > 1.5 && absXYZ > 7 && Z > 1){
    //   print('waliking');
    //   print('$X $Y $Z $_previousX, $_previousY $_previousZ $absXYZ $prevAbsXYZ');
    // }
    // print('$X $Y $Z $_previousX, $_previousY $_previousZ $absXYZ $prevAbsXYZ');
    bool isPeak = (X - Z > 2 && Y - Z > 2 && absXYZ > 10);
    if (isPeak){
      print('walking');
    }

    // Update previous values for next peak detection
    _previousX = X;
    _previousY = Y;
    _previousZ = Z;

    if(isPeak){
      print('step');
    }

    return isPeak;
  }


  void _onAccelerometerData(AccelerometerEvent event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await checkDateAndUpdate(prefs.getString('today')!);
    double currentZ = event.z;
    double currentX = event.x.abs();
    double currentY = event.y.abs();
    int stepCount = prefs.getInt('counter')!;
    await prefs.setInt('counterP', stepCount);
    if (_isPeak(currentX, currentY, currentZ)) {
      stepCount++;
      await prefs.setInt('counter', stepCount);
    }
    if(provider.steps == 0 && stepCount !=0){
      provider.addSteps(stepCount);
    }
    _isMoving().then((moving){
      if(moving){
        provider.addSteps(stepCount);
      }
    });

  }

  Future checkDateAndUpdate(String date) async {
    try {
      DateTime prefsToday = DateTime.parse(date);
      DateTime today = DateTime.now();
      bool isSameDay = prefsToday.year == today.year &&
          prefsToday.month == today.month &&
          prefsToday.day == today.day;
      if (!isSameDay) {
        print('today: $today, prefs: $prefsToday');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool result = await DailyTargetController.addOrUpdateSteps(
            DateFormat.yMMMMd().format(prefsToday), prefs.getInt('counter')!);
        await prefs.setInt('counter', 0);
        await prefs.setInt('counterP', 0);
        await prefs.setString('today', today.toString());
        await prefs.setString('yesterday', prefsToday.toString());
      }
    } catch (e) {
      rethrow;
    }
  }


  Future _isMoving() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int stepCount = prefs.getInt('counter')!;
    int stepCountP = prefs.getInt('counterP')!;
    //print('Moving compRE $stepCountP, $stepCount');
    return Future(() => stepCount != stepCountP);
  }
}