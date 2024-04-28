import 'package:flutter/material.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:health_companion_app/models/chart_data.dart';

class DailySleepChart extends StatelessWidget {
  const DailySleepChart({
    super.key,
    required this.chartData,
  });

  final List<ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SimpleCircularProgressBar(
            valueNotifier: ValueNotifier(chartData[0].y1),
            mergeMode: true,
            size: 200,
            progressColors: [kLightGreen],
            backColor: kInactiveCardColor,
            progressStrokeWidth: 25,
            maxValue: 24*60,
            onGetText: (double value) {
              return Text(
                '${value.toInt()} mins',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "Achieve optimal wellness by tracking your sleep patterns daily"
                " and striving for a consistent, quality rest every night.",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}