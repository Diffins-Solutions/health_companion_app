import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/sleep/music_list_card.dart';
import 'package:health_companion_app/screens/sleep/sleep_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/models/music_response_data.dart';
import 'package:health_companion_app/models/audio_streamer.dart';
import 'package:health_companion_app/screens/sleep/controls.dart';

class SingleAudioPlayer extends StatefulWidget {
  SingleAudioPlayer({Key? key, required this.response, required this.playList})
      : super(key: key);
  final MusicDataResponse response;
  final List<MusicDataResponse> playList;
  @override
  State<SingleAudioPlayer> createState() => _SingleAudioPlayerState();
}

class _SingleAudioPlayerState extends State<SingleAudioPlayer> {
  late AudioPlayer _audioPlayer;
  late ConcatenatingAudioSource _playlist;
  late AudioStreamer _audioStreamer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioStreamer =
        AudioStreamer(audioPlayer: _audioPlayer, playlist: widget.playList);
    _playlist = _audioStreamer.createPlayList();
    _audioStreamer.init(_playlist);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kActiveCardColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SleepScreen(
                  audioPlayer: _audioPlayer,
                ),
              ),
            );
          },
          icon: Icon(Icons.keyboard_arrow_left_rounded),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kActiveCardColor, Colors.black],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _audioStreamer.getAudioMetaData(),
            SizedBox(
              height: 70,
            ),
            _audioStreamer.getProgressBar(),
            SizedBox(
              height: 10,
            ),
            Controls(audioPlayer: _audioPlayer),
          ],
        ),
      ),
    );
  }
}
