import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:health_companion_app/widgets/welcome_text.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/screens/sleep/sleep_chart.dart';
import 'package:health_companion_app/screens/sleep/audio_player.dart';
import 'package:health_companion_app/models/chart_data.dart';
import 'package:expandable/expandable.dart';
import 'package:health_companion_app/services/api/api_service.dart';
import 'package:health_companion_app/models/music_response_data.dart';

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
  List<MusicDataResponse> musicList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchMusicData();
  }

  Future<void> fetchMusicData() async {
    final musiclist = await ApiService().getAllFetchMusicData();
    setState(() {
      musicList = musiclist;
    });
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeText(name: widget.name, today: widget.formattedDate),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/sleep_screen_backjpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.black.withAlpha(0),
                            Colors.black45,
                            Colors.black54
                          ],
                          stops: [0, 0, 0],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Your schedule",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                //TODO: Get the average time
                                SleepScheduleCard(
                                    time: "11.15 pm", isBedTime: true),
                                SizedBox(
                                  width: 20,
                                ),
                                SleepScheduleCard(
                                    time: "8.15 am", isBedTime: false),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ExpandablePanel(
                        header: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          child: Text(
                            "Statistics",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        collapsed: Text(""),
                        expanded: SizedBox(
                          height: 600,
                          child: Expanded(
                              flex: 2,
                              child:
                                  ChartSection(tabController: _tabController)),
                        ),
                        theme: ExpandableThemeData(
                            tapHeaderToExpand: true,
                            hasIcon: true,
                            iconColor: Colors.white)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Column(
                      children: [
                        Text(
                          "Latest Sleep Sounds",
                          style: TextStyle(fontSize: 15),
                        ),
                        // CustomListCard(musicList: musicList),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
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

class SleepScheduleCard extends StatelessWidget {
  const SleepScheduleCard(
      {super.key, required this.time, required this.isBedTime});

  final String time;
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
              time,
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

class CustomListCard extends StatelessWidget {
  const CustomListCard({super.key, required this.musicList});

  final List<MusicDataResponse> musicList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SingleAudioPlayer(response: musicList[index]),
              ),
            );
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, bottom: 8, right: 8, top: 4),
                  child: SizedBox(
                    child: FadeInImage.assetNetwork(
                        height: 60,
                        width: 60,
                        placeholder: "lib/assets/images/musicplaceholder.png",
                        image: musicList[index].image.toString(),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      musicList[index].title.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      musicList[index].artist.toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      itemCount: musicList.length,
    );
  }
}
