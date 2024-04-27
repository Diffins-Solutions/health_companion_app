import 'package:flutter/material.dart';
import 'package:health_companion_app/models/chart_data.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/widgets/chart.dart';

class ChartSection extends StatelessWidget {

  List<ChartData> weeklyData;
  List<ChartData> monthlyData;
  List<ChartData> yearlyData;

  ChartSection({
    super.key,
    required TabController tabController,
    required this.monthlyData,
    required this.weeklyData,
    required this.yearlyData
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TabBar(
            controller: _tabController, // Use the provided _tabController
            indicatorSize: TabBarIndicatorSize.tab,
            splashBorderRadius: BorderRadius.circular(20),
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: kActiveCardColor),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(
                icon: Text('Weekly'),
              ),
              Tab(
                icon: Text('Monthly'),
              ),
              Tab(
                icon: Text('Yearly'),
              ),
            ],
          ),
        ),
        Flexible(
          child: TabBarView(
            controller: _tabController, // Use the provided _tabController
            children: [
              Chart(
                chartData: weeklyData,
              ),
              Chart(chartData: monthlyData),
              Chart(chartData: yearlyData),
            ],
          ),
        ),
      ],
    );
  }
}