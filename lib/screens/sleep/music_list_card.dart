import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/sleep/single_audio_player.dart';
import 'package:health_companion_app/models/music_response_data.dart';
import 'package:just_audio/just_audio.dart';

class MusicListCard extends StatefulWidget {
  const MusicListCard({super.key, required this.musicList, this.audioPlayer});

  final List<MusicDataResponse> musicList;
  final AudioPlayer? audioPlayer;

  @override
  State<MusicListCard> createState() => _MusicListCardState();
}

class _MusicListCardState extends State<MusicListCard> {

  late AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: ()  async {
              var audioPlayer = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleAudioPlayer(
                      response: widget.musicList[index], playList: widget.musicList),
                ),
              );
              setState(() {
                audioPlayer = audioPlayer;
              });
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
                          placeholder: "images/night_sky.png",
                          image: widget.musicList[index].image.toString(),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.musicList[index].title.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.musicList[index].artist.toString(),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        itemCount: widget.musicList.length,
      ),
      Container(
        margin: EdgeInsets.only(top: 200),
        width: double.infinity,
        height: 100,
        color: Colors.red,
        child: Text("${audioPlayer.currentIndex}"),
      ),
    ]);
  }
}
