import 'package:flutter/material.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/widgets/chart.dart';
import 'package:health_companion_app/widgets/welcome_text.dart';
import 'package:intl/intl.dart';

import '../../models/chart_data.dart';

/// 1. sadness => 🙁
/// 2. joy => 😀
/// 3. love => 🥰
/// 4. anger => 😡
/// 5. fear => 😰
/// 6. surprise => 😲
///

final List<ChartData> yearlyData = [
  ChartData('Jan', 10, 8, 7, 12, 24, 8),
  ChartData('Feb', 11, 8, 7, 12, 24, 19),
  ChartData('Mar', 14, 8, 7, 12, 10, 8),
  ChartData('Apr', 3, 8, 3, 12, 24, 3),
  ChartData('May', 6, 8, 7, 12, 24, 8),
  ChartData('Jun', 10, 6, 7, 12, 4, 8),
  ChartData('Jul', 14, 8, 20, 12, 24, 8),
  ChartData('Aug', 10, 8, 7, 4, 24, 8),
  ChartData('Sep', 5, 8, 7, 12, 24, 10),
  ChartData('Oct', 10, 8, 7, 3, 24, 8),
  ChartData('Nov', 15, 2, 7, 12, 24, 8),
  ChartData('Dec', 24, 8, 7, 12, 24, 8),
];

final List<ChartData> monthlyData = [
  ChartData('Week 1', 10, 8, 7, 12, 24, 8),
  ChartData('Week 2', 11, 8, 7, 12, 24, 19),
  ChartData('Week 3', 14, 8, 7, 12, 10, 8),
  ChartData('Week 4', 3, 8, 3, 12, 24, 3),
];

final List<ChartData> weeklyData = [
  ChartData('Mon', 10, 8, 7, 12, 24, 8),
  ChartData('Tue', 11, 8, 7, 12, 24, 19),
  ChartData('Wed', 14, 8, 7, 12, 10, 8),
  ChartData('Thu', 3, 8, 3, 12, 24, 3),
  ChartData('Fri', 6, 8, 7, 12, 24, 8),
  ChartData('Sat', 10, 6, 7, 12, 4, 8),
  ChartData('Sun', 14, 8, 20, 12, 24, 8),
];

class MoodScreen extends StatefulWidget {
  final String name = 'Nethmi';
  String formattedDate = DateFormat.yMMMMd().format(DateTime.now());

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          Expanded(child: InputEmotion(textController: _textController)),
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

class InputEmotion extends StatefulWidget {
  const InputEmotion({
    super.key,
    required TextEditingController textController,
  }) : _textController = textController;

  final TextEditingController _textController;

  @override
  State<InputEmotion> createState() => _InputEmotionState();
}

class _InputEmotionState extends State<InputEmotion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'How are you feeling now ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: TextField(
                  controller: widget._textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  minLines: 3,
                  decoration: InputDecoration(
                      fillColor: kActiveCardColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.transparent),
                      )),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(
                    size: 35,
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      print('My thought is ${widget._textController.text}');
                      widget._textController.clear();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
