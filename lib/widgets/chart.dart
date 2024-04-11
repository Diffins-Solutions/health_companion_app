import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../models/chart_data.dart';

class Chart extends StatelessWidget {

  TooltipBehavior ?_tooltipBehavior;
  List<ChartData> chartData;

  Chart({required this.chartData}){
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {

    return Center(
        child: SfCartesianChart(
          title: ChartTitle(text: 'Emotion Analysis', textStyle: TextStyle(fontSize: 13)),
            primaryXAxis: CategoryAxis(),
            tooltipBehavior: _tooltipBehavior,
            series: <CartesianSeries>[
              StackedColumnSeries<ChartData, String>(
                name: 'Sad',
                enableTooltip: true,
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y1,
                color: Colors.blue,
              ),
              StackedColumnSeries<ChartData, String>(
                name: 'Joy',
                enableTooltip: true,
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                color: Colors.yellow,
              ),
              StackedColumnSeries<ChartData,String>(
                name: 'Love',
                enableTooltip: true,
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y3,
                color: Colors.red,
              ),
              StackedColumnSeries<ChartData, String>(
                name: 'Angry',
                enableTooltip: true,
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y4,
                color: Colors.deepPurpleAccent,

              ),
              StackedColumnSeries<ChartData, String>(
                name: 'Fear',
                enableTooltip: true,
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y5,
                color: Colors.green,
              ),
              StackedColumnSeries<ChartData, String>(
                name: 'Surprise',
                enableTooltip: true,
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y6,
                color: Colors.pink,
              )
            ]
        )
    );
  }
}

