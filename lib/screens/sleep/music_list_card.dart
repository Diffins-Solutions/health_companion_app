import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/sleep/single_audio_player.dart';
import 'package:health_companion_app/models/music_response_data.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MusicListCard extends StatefulWidget {
  const MusicListCard({super.key, required this.musicList, this.audioPlayer});

  final List<MusicDataResponse> musicList;
  final AudioPlayer? audioPlayer;

  @override
  State<MusicListCard> createState() => _MusicListCardState();
}

class _MusicListCardState extends State<MusicListCard> {
  bool _isLoading = false;

  void _setIsLoading() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 10));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    _setIsLoading();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleAudioPlayer(
                      index: index, playList: widget.musicList, audioPlayer: widget.audioPlayer,),
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
    );
  }
}
