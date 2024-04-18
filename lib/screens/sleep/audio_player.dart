import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/models/music_response_data.dart';

class PositionData {
  const PositionData(this.position, this.bufferedPosition, this.duration);

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

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

  Stream<PositionData> get _positionDataSream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  ConcatenatingAudioSource _createPlayList() {
    List<AudioSource> _songs = [];
    for (MusicDataResponse response in widget.playList) {
      _songs.add(AudioSource.uri(Uri.parse("https://storage.googleapis.com/uamp/The_Kyoto_Connection_-_Wake_Up/08_-_Reveal_the_Magic.mp3"),
          tag: MediaItem(
              id: response.id.toString(),
              title: response.title.toString(),
              artist: response.artist.toString(),
              artUri: Uri.parse(response.image.toString()))));
    }
    return ConcatenatingAudioSource(children: _songs);
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer()..setAsset("audio/test_audio.mp3");
    _playlist = _createPlayList();
    _init();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(_playlist);
}

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.response.image.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kActiveCardColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                height: MediaQuery.of(context).size.height / 2.75,
                url,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              widget.response.title.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              widget.response.artist.toString(),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 70,
            ),
            StreamBuilder(
              stream: _positionDataSream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return ProgressBar(
                  barHeight: 8,
                  baseBarColor: Colors.grey,
                  bufferedBarColor: Colors.grey,
                  progressBarColor: Colors.red,
                  thumbColor: Colors.red,
                  timeLabelTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  progress: positionData?.position ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  buffered: positionData?.duration ?? Duration.zero,
                  onSeek: _audioPlayer.seek,
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Controls(audioPlayer: _audioPlayer),
          ],
        ),
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, twoDigitMinutes, twoDigitSeconds]
        .join(':');
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed:() async => {await audioPlayer.seekToPrevious()},
          icon: Icon(
            Icons.skip_previous_outlined,
            size: 60,
            color: Colors.white,
          ),
        ),
        StreamBuilder(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;

            if (!(playing ?? false)) {
              return IconButton(
                onPressed: () async => {await audioPlayer.play()},
                icon: Icon(Icons.play_arrow_rounded),
                iconSize: 80,
                color: Colors.white,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: () async => {await audioPlayer.pause()},
                icon: Icon(Icons.pause_rounded),
                iconSize: 80,
                color: Colors.white,
              );
            }
            return Icon(
              Icons.play_arrow_rounded,
              size: 80,
              color: Colors.white,
            );
          },
        ),
        IconButton(
          onPressed: () async => {await audioPlayer.seekToNext()},
          icon: Icon(
            Icons.skip_next_outlined,
            size: 60,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
