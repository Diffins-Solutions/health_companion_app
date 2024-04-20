import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_companion_app/models/audio_streamer.dart';
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
  late NetworkHelper networkHelper = NetworkHelper(Uri.parse("https://storage.googleapis.com/uamp/catalog.json"));
  List<MusicDataResponse> musicList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    audioStreamer = AudioStreamer(
        audioPlayer: widget.audioPlayer,
        playlist: musicList,
        isMiniPlayer: true);
    fetchMusicData();
  }

  Future<void> fetchMusicData() async {
    var response = await networkHelper.getData();
    var songs = response.data["music"]  as List<dynamic>;
    setState(() {
      musicList = songs.map( (e) {
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
                                  ChartSection(tabController: _tabController),
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
                          index: widget.audioPlayer!.currentIndex, playList: musicList, audioPlayer: widget.audioPlayer,),
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
