import 'package:arc_progress_bar_new/arc_progress_bar_new.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_companion_app/models/steps_notifer.dart';
import 'package:provider/provider.dart';
import '../../models/step_counter.dart';
import '../../utils/constants.dart';

class StepCounterWidget extends StatelessWidget {
  StepCounterWidget({
    required this.targetSteps,
  }) ;

  final int targetSteps;

  @override
  Widget build(BuildContext context) {
    final  provider = Provider.of<StepNotifier>(context, listen: true);
    final stepCounter = StepCounter(provider: provider);
    stepCounter.startListening();
    int currentStepCount = provider.steps ;
    return Padding(
      padding:
      const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
      child: ArcProgressBar(
          percentage: targetSteps == 0 ? 0 :(currentStepCount/targetSteps)*100,
          bottomLeftWidget: Text(
            "Begin",
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          bottomRightWidget: Text(
            '$currentStepCount / $targetSteps',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          bottomCenterWidget: Text(
            "STEPS",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          centerWidget: Icon(
            FontAwesomeIcons.walking,
            size: 50,
          ),
          arcThickness: 25,
          innerPadding: 15,
          animateFromLastPercent: true,
          handleSize: 0,
          backgroundColor: Colors.white30,
          foregroundColor: kLightGreen),
    );
  }
}
