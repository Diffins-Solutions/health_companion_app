import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_companion_app/contollers/user_controller.dart';
import 'package:health_companion_app/screens/app_shell.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:heart_bpm/heart_bpm.dart';

class HeartRateWidget extends StatefulWidget {
  const HeartRateWidget({required this.userId});

  final int userId;

  @override
  State<HeartRateWidget> createState() => _HeartRateWidgetState();
}

class _HeartRateWidgetState extends State<HeartRateWidget> {
  /// List to store raw values in
  List<SensorValue> data = [];

  /// Variable to store measured BPM value
  int bpmValue = 0;

  /// Timer to handle automatic measurement duration
  Timer? measurementTimer;

  /// Flag to indicate if measurement is ongoing
  bool isMeasurementRunning = false;

  ///Remaining time
  int remainingTime = 30;

  Future<void> updateHeartRate() async {
    await UserController.updateHeartRate(widget.userId, bpmValue);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    measurementTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measure your heart rate', style: TextStyle(fontSize: kSubHeadingSize)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamed(context, AppShell.id);
          },
        ),
        backgroundColor: kBackgroundColor,
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isMeasurementRunning
                ? HeartBPMDialog(
              context: context,
              onRawData: (value) {
                setState(() {
                  // Add raw data points to the list with a maximum length of 100
                  if (data.length == 100) data.removeAt(0);
                  data.add(value);
                });
              },
              onBPM: (value) => setState(() {
                bpmValue = value;
              }),
            )
                : SizedBox(),
            SizedBox(height: 10),
            Text('Place your finger over both the camera and the flash light\n for 30 seconds', textAlign: TextAlign.center,),
            SizedBox(height: 10),
            isMeasurementRunning ? Text('Remaining Time: $remainingTime'): Container(),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.favorite_rounded, color: kLightGreen),
                label: Text(isMeasurementRunning ? "Stop measurement" : "Start measurement", style: TextStyle(color: kLightGreen)),
                onPressed: () {
                  setState(() {
                    isMeasurementRunning = !isMeasurementRunning;
                    if (isMeasurementRunning) {
                      // Reset remaining time and start timer
                      remainingTime = 30;
                      measurementTimer?.cancel();
                      measurementTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                        setState(() {
                          remainingTime--;
                          if (remainingTime == 0) {
                            isMeasurementRunning = false;
                            updateHeartRate();
                            timer.cancel();
                          }
                        });
                      });
                    } else {
                      measurementTimer?.cancel();
                    }
                  });
                },
              ),
            ),
            Text('$bpmValue bpm'),
          ],
        ),
      ),
    );
  }
}
