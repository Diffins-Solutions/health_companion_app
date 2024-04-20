import 'package:health_companion_app/models/position_data.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:health_companion_app/models/music_response_data.dart';
import 'package:audio_service/audio_service.dart';
import 'package:health_companion_app/screens/sleep/media_meta_data_section.dart';

class AudioStreamer {
  const AudioStreamer(
      {this.audioPlayer, required this.playlist, required this.isMiniPlayer});

  final AudioPlayer? audioPlayer;
  final bool isMiniPlayer;
  final List<MusicDataResponse> playlist;

  Future<void> init(audioSources, initialIndex) async {
    await audioPlayer!.setLoopMode(LoopMode.all);
    await audioPlayer!.setAudioSource(audioSources, initialIndex: initialIndex);
  }

  Stream<PositionData> get _positionDataSream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        audioPlayer!.positionStream,
        audioPlayer!.bufferedPositionStream,
        audioPlayer!.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  StreamBuilder<SequenceState?> getAudioMetaData() {
    return StreamBuilder<SequenceState?>(
      stream: audioPlayer!.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource?.tag as MediaItem;
        return MediaMetaData(
          imageURL: metadata.artUri.toString(),
          title: metadata.title.toString(),
          artist: metadata.artist.toString(),
          isMiniPlayer: isMiniPlayer,
        );
      },
    );
  }

  StreamBuilder<PositionData> getProgressBar() {
    return StreamBuilder<PositionData>(
      stream: _positionDataSream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          child: ProgressBar(
            barHeight: isMiniPlayer ? 3 : 6,
            baseBarColor: Colors.grey,
            bufferedBarColor: Colors.grey,
            progressBarColor: Colors.red,
            thumbColor: Colors.red,
            timeLabelTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: isMiniPlayer ? 10 : 15,
            ),
            progress: positionData?.position ?? Duration.zero,
            total: positionData?.duration ?? Duration.zero,
            buffered: positionData?.duration ?? Duration.zero,
            onSeek: audioPlayer!.seek,
          ),
        );
      },
    );
  }

  AudioSource _createSource(MusicDataResponse response) {
    return AudioSource.uri(
      Uri.parse(response.source.toString()),
      tag: MediaItem(
        id: response.id.toString(),
        title: response.title.toString(),
        artist: response.artist.toString(),
        artUri: Uri.parse(
          response.image.toString(),
        ),
      ),
    );
  }

  ConcatenatingAudioSource createPlayList() {
    List<AudioSource> _songs = [];
    for (MusicDataResponse response in playlist) {
      _songs.add(
          _createSource(response)
      );
    }
    return ConcatenatingAudioSource(children: _songs);
  }
}
