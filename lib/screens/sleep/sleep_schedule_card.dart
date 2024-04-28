import 'package:flutter/material.dart';
import 'package:health_companion_app/utils/constants.dart';

class SleepScheduleCard extends StatelessWidget {
  const SleepScheduleCard(
      {super.key, this.time, required this.isBedTime});

  final String? time;
  final bool isBedTime;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kInactiveCardColor,
          border: Border.all(
            color: kActiveCardColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.bed),
            Text(
              time!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              isBedTime ? "Bedtime" : "Wake up",
              style: TextStyle(
                  fontSize: 17,
                  color: Color(0xF017736a),
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}