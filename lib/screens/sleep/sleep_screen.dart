import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_companion_app/contollers/daily_sleep_controller.dart';
import 'package:health_companion_app/contollers/sleep_target_controller.dart';
import 'package:health_companion_app/models/audio_streamer.dart';
import 'package:health_companion_app/models/db_models/daily_sleep.dart';
import 'package:health_companion_app/models/db_models/sleep_target.dart';
import 'package:health_companion_app/screens/sleep/controls.dart';
import 'package:health_companion_app/screens/sleep/single_audio_player.dart';
import 'package:intl/intl.dart';
import 'package:health_companion_app/widgets/welcome_text.dart';
import 'package:health_companion_app/screens/sleep/sleep_schedule_card.dart';
import 'package:health_companion_app/screens/sleep/chart_section.dart';
import 'package:health_companion_app/screens/sleep/music_list_card.dart';
import 'package:expandable/expandable.dart';
import 'package:health_companion_app/services/api/networking.dart';
import 'package:health_companion_app/models/music_response_data.dart';
import 'package:just_audio/just_audio.dart';
import 'package:health_companion_app/utils/constants.dart';

Map<int, String> weekDays = {
  1: 'M',
  2: 'T',
  3: 'W',
  4: 'Th',
  5: 'F',
  6: 'St',
  7: 'S'
};

int getTimeInBedMins(TimeOfDay sleepTime, TimeOfDay wakeupTime) {
  Duration start = Duration(hours: sleepTime.hour, minutes: sleepTime.minute);
  Duration end = Duration(hours: wakeupTime.hour, minutes: wakeupTime.minute);

  return (end - start).inMinutes.abs();
}

class SleepScreen extends StatefulWidget {
  SleepScreen({this.audioPlayer});

  final AudioPlayer? audioPlayer;

  final String name = 'Nethmi';
  String formattedDate = DateFormat.yMMMMd().format(DateTime.now());

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late AudioStreamer audioStreamer;
  late final String? today;
  late TimeOfDay? scheduledWakeUp;
  late TimeOfDay? scheduledSleep;
  TimeOfDay? wakeup;
  TimeOfDay? sleep;
  late int todayTimeInBed = getTimeInBedMins(scheduledWakeUp!, scheduledSleep!);
  late NetworkHelper networkHelper = NetworkHelper(
      Uri.parse("https://storage.googleapis.com/uamp/catalog.json"));
  List<MusicDataResponse> musicList = [];
  final TextEditingController _wakeupTimeController = TextEditingController();
  final TextEditingController _sleepTimeController = TextEditingController();
  final String todayDate = DateFormat.yMMMMd().format(DateTime.now());

  void addSleepData (int mins) async {
    DailySleep sleepData = DailySleep(day: todayDate, mins: mins);
    print('adding sleep schedule');
    await DailySleepController.addSleepData(sleepData);
  }

  void updateSleepData (int mins) async {
    DailySleep sleepData = DailySleep(day: todayDate, mins: mins);
    print('updating sleep schedule');
    await DailySleepController.updateSleepData(sleepData);
  }

  void getSleepTarget() async {
    SleepTarget? sleepTarget =
        await SleepTargetController.getDailySleepData(today);

    scheduledSleep = convertTime(sleepTarget?.sleep);
    scheduledWakeUp = convertTime(sleepTarget?.wakeup);
  }

  String getTimeOfDay(DayPeriod period) {
    return period.name == 'am' ? 'AM' : 'PM';
  }

  TimeOfDay convertTime(String? unformattedtime){
    if (unformattedtime != null) {
      List<String> timeParts = unformattedtime.split(":");
      int hours = int.parse(timeParts[0]);
      int mins = int.parse(timeParts[1]);
      return TimeOfDay(hour: hours, minute: mins);
    }
      return TimeOfDay(hour: 00, minute: 00);
  }

  String getTimeString(TimeOfDay time) {
    int hours = time.hour == 0 ? 12 : time.hour < 12 ? time.hour : time.hour - 12;

    return "$hours.${time.minute} ${getTimeOfDay(time.period)}";
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    today = weekDays[DateTime.now().weekday];
    audioStreamer = AudioStreamer(
        audioPlayer: widget.audioPlayer,
        playlist: musicList,
        isMiniPlayer: true);
    scheduledWakeUp = TimeOfDay(hour: 8, minute: 15);
    scheduledSleep = TimeOfDay(hour: 22, minute: 00);
    fetchMusicData();
    getSleepTarget();
    addSleepData(todayTimeInBed);
  }

  Future<void> fetchMusicData() async {
    var response = await networkHelper.getData();
    var songs = response.data["music"] as List<dynamic>;
    setState(() {
      musicList = songs.map((e) {
        return MusicDataResponse.fromJson(e);
      }).toList();
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
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeText(name: widget.name, today: widget.formattedDate),
              Expanded(
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                              children: [
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
                                        time: getTimeString(scheduledSleep!),
                                        isBedTime: true),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    SleepScheduleCard(
                                        time: getTimeString(scheduledWakeUp!),
                                        isBedTime: false),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 20),
                        child: Text(
                          "Your record for today ..",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: TextFormField(
                                    controller: _wakeupTimeController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      hintText: 'Wakeup Time',
                                      hintStyle: TextStyle(
                                        fontSize: kNormalSize,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  TimeOfDay? selectedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                    builder: (context, child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                            colorScheme: kTimePickerTheme),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (selectedTime != null) {
                                    setState(() {
                                      wakeup = selectedTime;
                                      final now = DateTime.now();
                                      final time = DateTime(now.year, now.month,
                                          now.day, wakeup!.hour, wakeup!.minute);
                                      _wakeupTimeController.text =
                                          DateFormat('hh:mm a').format(time);
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  TimeOfDay? selectedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                    builder: (context, child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                            colorScheme: kTimePickerTheme),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (selectedTime != null) {
                                    setState(() {
                                      sleep = selectedTime;
                                      todayTimeInBed = getTimeInBedMins(sleep!, wakeup!);
                                      updateSleepData(todayTimeInBed);
                                      final now = DateTime.now();
                                      final time = DateTime(now.year, now.month,
                                          now.day, sleep!.hour, sleep!.minute);
                                      _sleepTimeController.text =
                                          DateFormat('hh:mm a').format(time);
                                    });
                                  }
                                },
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: TextFormField(
                                    controller: _sleepTimeController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      hintText: 'Sleep Time',
                                      hintStyle: TextStyle(
                                        fontSize: kNormalSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5),
                        child: ExpandablePanel(
                            header: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5.0),
                              child: Text(
                                "Statistics",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            collapsed: Text(""),
                            expanded: SizedBox(
                              height: 530,
                              child:
                                  ChartSection(tabController: _tabController, todayTimeInBed: todayTimeInBed),
                            ),
                            theme: ExpandableThemeData(
                                tapHeaderToExpand: true,
                                hasIcon: true,
                                iconColor: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0),
                        child: ExpandablePanel(
                            header: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5.0),
                              child: Text(
                                "Latest Sleep Sounds",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            collapsed: Text(""),
                            expanded: SizedBox(
                              height: 530,
                              child: MusicListCard(
                                musicList: musicList,
                                audioPlayer: widget.audioPlayer,
                              ),
                            ),
                            theme: ExpandableThemeData(
                                tapHeaderToExpand: true,
                                hasIcon: true,
                                iconColor: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Embrace the soothing symphony of sleep music and the insightful journey of sleep tracking, for they are the silent whispers "
                          "that guide you to a realm of tranquil dreams and restful nights.",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          (widget.audioPlayer != null && widget.audioPlayer!.playing)
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleAudioPlayer(
                          index: widget.audioPlayer!.currentIndex,
                          playList: musicList,
                          audioPlayer: widget.audioPlayer,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    height: 100,
                    color: Color(0xFF021A1A),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: audioStreamer.getAudioMetaData(),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 30),
                            child: Column(
                              children: [
                                Expanded(child: audioStreamer.getProgressBar()),
                                Controls(
                                  audioPlayer: widget.audioPlayer,
                                  isMiniPlayer: true,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
