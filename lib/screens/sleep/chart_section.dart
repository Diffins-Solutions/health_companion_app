import 'package:flutter/material.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/screens/sleep/sleep_chart.dart';
import 'package:health_companion_app/models/chart_data.dart';


class ChartSection extends StatelessWidget {
  ChartSection({
    super.key,
    required TabController tabController,
    this.timeInBed
  }) : _tabController = tabController;

  final TabController _tabController;
  final int? timeInBed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
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
                icon: Text(
                  'D',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                icon: Text(
                  'W',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                icon: Text(
                  'M',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                icon: Text(
                  'Y',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: TabBarView(
            controller: _tabController, // Use the provided _tabController
            children: [
              SleepChart(
                tabName: 'D',
                timeInBed: timeInBed,
              ),
              SleepChart(
                tabName: 'W',
              ),
              SleepChart(
                tabName: 'M',
              ),
              SleepChart(
                tabName: 'Y',
              )
            ],
          ),
        ),
      ],
    );
  }
}