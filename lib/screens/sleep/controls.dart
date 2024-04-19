import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () async => {await audioPlayer.seekToPrevious()},
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