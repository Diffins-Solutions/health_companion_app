import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/widgets/chart.dart';
import 'package:intl/intl.dart';

import '../../models/chart_data.dart';
import '../app_shell.dart';

/// 1. sadness => 🙁
/// 2. joy => 😀
/// 3. love => 🥰
/// 4. anger => 😡
/// 5. fear => 😰
/// 6. surprise => 😲
///

final List<ChartData> yearlyData = [
  ChartData('Jan', 10, y2: 8, y3: 7, y4: 12, y5: 24, y6: 8),
  ChartData('Feb', 11, y2: 8, y3: 7, y4: 12, y5: 24, y6: 19),
  ChartData('Mar', 14, y2: 8, y3: 7, y4: 12, y5: 10, y6: 8),
  ChartData('Apr', 3, y2: 8, y3: 3, y4: 12, y5: 24, y6: 3),
  ChartData('May', 6, y2: 8, y3: 7, y4: 12, y5: 24, y6: 8),
  ChartData('Jun', 10, y2: 6, y3: 7, y4: 12, y5: 4, y6: 8),
  ChartData('Jul', 14, y2: 8, y3: 20, y4: 12, y5: 24, y6: 8),
  ChartData('Aug', 10, y2: 8, y3: 7, y4: 4, y5: 24, y6: 8),
  ChartData('Sep', 5, y2: 8, y3: 7, y4: 12, y5: 24, y6: 10),
  ChartData('Oct', 10, y2: 8, y3: 7, y4: 3, y5: 24, y6: 8),
  ChartData('Nov', 15, y2: 2, y3: 7, y4: 12, y5: 24, y6: 8),
  ChartData('Dec', 24, y2: 8, y3: 7, y4: 12, y5: 24, y6: 8),
];

final List<ChartData> monthlyData = [
  ChartData('Week 1', 10, y2: 8, y3: 7, y4: 12, y5: 24, y6: 8),
  ChartData('Week 2', 11, y2: 8, y3: 7, y4: 12, y5: 24, y6: 19),
  ChartData('Week 3', 14, y2: 8, y3: 7, y4: 12, y5: 10, y6: 8),
  ChartData('Week 4', 3, y2: 8, y3: 3, y4: 12, y5: 24, y6: 3),
];

final List<ChartData> weeklyData = [
  ChartData('Mon', 10, y2: 8, y3: 7, y4: 12, y5: 24, y6: 8),
  ChartData('Tue', 11, y2: 8, y3: 7, y4: 12, y5: 24, y6: 19),
  ChartData('Wed', 14, y2: 8, y3: 7, y4: 12, y5: 10, y6: 8),
  ChartData('Thu', 3, y2: 8, y3: 3, y4: 12, y5: 24, y6: 3),
  ChartData('Fri', 6, y2: 8, y3: 7, y4: 12, y5: 24, y6: 8),
  ChartData('Sat', 10, y2: 6, y3: 7, y4: 12, y5: 4, y6: 8),
  ChartData('Sun', 14, y2: 8, y3: 20, y4: 12, y5: 24, y6: 8),
];

class MoodScreen extends StatefulWidget {
  final String formattedDate = DateFormat.yMMMMd().format(DateTime.now());
  final List<String>? dassScores;

  MoodScreen({super.key, this.dassScores});

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
    return Expanded(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            children: [
              Expanded(
                  flex: 2, child: ChartSection(tabController: _tabController)),
              Expanded(child: InputEmotion(textController: _textController)),
            ],
          ),
          (widget.dassScores != null)
              ? AlertBox(scores: widget.dassScores!)
              : Container()
        ],
      ),
    );
  }
}

class AlertBox extends StatefulWidget {
  final List<String> scores;
  AlertBox({required this.scores});

  @override
  _AlertBoxState createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  @override
  void initState() {
    super.initState();
  }

  List<String>? recommendedTips(List<String> results) {
    List<String> recommendations = ["depression", "stress", "anxiety"];
    List<String> finalRecommendations = [];

    for (var i = 0; i < recommendations.length; i++) {
      if (results[i] != "Normal") {
        finalRecommendations.add(recommendations[i]);
      }
    }
    return finalRecommendations.isNotEmpty ? finalRecommendations : null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          color: Colors.black.withOpacity(0.6),
        ),
        Container(
          padding: EdgeInsets.all(20),
          height: 270,
          width: 300,
          color: kActiveCardColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your DASS 21 Score',
                style: TextStyle(
                    fontFamily: "Hind-Regular",
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.grey,
                height: 5, // You can adjust the height as needed
                thickness: 1,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Depression",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 2),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        widget.scores[0],
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Anxiety",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ),
                      SizedBox(
                        width: 64,
                      ),
                      Text(widget.scores[1]),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Stress",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ),
                      SizedBox(
                        width: 78,
                      ),
                      Text(widget.scores[2]),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppShell(
                              currentIndex: 1,
                            )),
                      );
                    },
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Hind-Regular",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppShell(
                                  currentIndex: 2,
                                  healthTipsKeyWords:
                                      recommendedTips(widget.scores),
                                )),
                      );
                    },
                    child: Text(
                      "GET HEALTH TIPS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Hind-Regular",
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
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
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Successfully updated!')));
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
