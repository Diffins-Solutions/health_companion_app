import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

class StepCounter {
  final double _zThreshold;
  final double _xyThreshold;
  int _stepCount;
  StreamSubscription<AccelerometerEvent>? _streamSubscription;
  double _previousZ = 0.0; // Added for peak detection
  final Stream<int> stepCountStream = StreamController<int>.broadcast().stream;

  StepCounter({double zThreshold = 2.0, double xyThreshold = 0.5})
      : _zThreshold = zThreshold,
        _xyThreshold = xyThreshold,
        _stepCount = 0;

  Future<void> startListening() async {
    if (_streamSubscription == null) {
      _streamSubscription = accelerometerEvents.listen(_onAccelerometerData);
    }
  }

  void stopListening() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  int get stepCount => _stepCount;

  bool _isPeak(double value) {
    // Simple peak detection based on change in Z-axis
    bool isPeak = value.abs() > _zThreshold && value * _previousZ < 0;
    _previousZ = value; // Update for next peak detection
    return isPeak;
  }

  void _onAccelerometerData(AccelerometerEvent event) {
    double currentZ = event.z;
    double currentX = event.x.abs();
    double currentY = event.y.abs();

    if (_isPeak(currentZ)) {
      if (currentX > _xyThreshold || currentY > _xyThreshold) {
        _stepCount++;
        (stepCountStream as StreamController<int>).add(_stepCount);
      }
    }
    print("Step count: $_stepCount");
  }

}