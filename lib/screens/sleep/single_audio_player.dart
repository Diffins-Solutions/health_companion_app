import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/app_shell.dart';
import 'package:health_companion_app/screens/sleep/music_list_card.dart';
import 'package:health_companion_app/screens/sleep/sleep_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/models/music_response_data.dart';
import 'package:health_companion_app/models/audio_streamer.dart';
import 'package:health_companion_app/screens/sleep/controls.dart';

class SingleAudioPlayer extends StatefulWidget {
  SingleAudioPlayer({Key? key, this.index, required this.playList, this.audioPlayer})
      : super(key: key);
  final int? index;
  final List<MusicDataResponse> playList;
  final AudioPlayer? audioPlayer;
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
    print(widget.index);
    _audioPlayer = widget.audioPlayer ?? AudioPlayer();
    _audioStreamer = AudioStreamer(
        audioPlayer: _audioPlayer,
        playlist: widget.playList,
        isMiniPlayer: false);
    if (widget.audioPlayer == null) {
      _playlist = _audioStreamer.createPlayList();
      _audioStreamer.init(_playlist, widget.index);
    }
    if (_audioPlayer.playing) {
      if (widget.index == _audioPlayer.currentIndex) {
        _audioPlayer.seek(_audioPlayer.position, index:widget.index);
      }else{
        _audioPlayer.seek(Duration.zero, index:widget.index);
      }
    } else {
      _audioPlayer.seek(_audioPlayer.position, index:widget.index);
    }
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
                builder: (context) => AppShell(
                  currentIndex: 3,
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
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _audioStreamer.getAudioMetaData(),
            SizedBox(
              height: 70,
            ),
            _audioStreamer.getProgressBar(),
            Controls(
              audioPlayer: _audioPlayer,
              isMiniPlayer: false,
            ),
          ],
        ),
      ),
    );
  }
}
