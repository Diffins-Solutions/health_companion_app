import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:health_companion_app/widgets/welcome_text.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/screens/sleep/sleep_chart.dart';
import 'package:health_companion_app/models/chart_data.dart';

// in mins
//TODO: But actually times should receive as DateTime and should calculate the sum of hours
final List<ChartData> yearlyData = [
  ChartData('Jan', 100000),
  ChartData('Feb', 11000),
  ChartData('Mar', 14000),
  ChartData('Apr', 30000),
  ChartData('May', 60000),
  ChartData('Jun', 10000),
  ChartData('Jul', 14000),
  ChartData('Aug', 10000),
  ChartData('Sep', 50000),
  ChartData('Oct', 10000),
  ChartData('Nov', 15000),
  ChartData('Dec', 24000),
];

final List<ChartData> monthlyData = [
  ChartData('Week 1', 10000),
  ChartData('Week 2', 11000),
  ChartData('Week 3', 1400),
  ChartData('Week 4', 300),
];

final List<ChartData> weeklyData = [
  ChartData(
    'Mon',
    10,
  ),
  ChartData('Tue', 1100),
  ChartData('Wed', 1400),
  ChartData('Thu', 3000),
  ChartData('Fri', 6000),
  ChartData('Sat', 10000),
  ChartData('Sun', 1400),
];

final List<ChartData> dailyData = [
  ChartData(
    '',
    10,
  ),
];

class SleepScreen extends StatefulWidget {
  final String name = 'Nethmi';
  String formattedDate = DateFormat.yMMMMd().format(DateTime.now());

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          WelcomeText(name: widget.name, today: widget.formattedDate),
          Expanded(flex: 2, child: ChartSection(tabController: _tabController)),
        ],
      ),
    );
  }
}

class ChartSection extends StatelessWidget {
  const ChartSection({
    super.key,
    required TabController tabController,
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
                chartData: dailyData,
              ),
              SleepChart(
                tabName: 'W',
                chartData: weeklyData,
              ),
              SleepChart(
                tabName: 'M',
                chartData: monthlyData,
              ),
              SleepChart(
                tabName: 'Y',
                chartData: yearlyData,
              )
            ],
          ),
        ),
      ],
    );
  }
}
