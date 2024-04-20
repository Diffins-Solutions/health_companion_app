import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MediaMetaData extends StatelessWidget {
  const MediaMetaData({
    super.key,
    required this.imageURL,
    required this.title,
    required this.artist,
    required this.isMiniPlayer,
  });

  final String imageURL;
  final String title;
  final String artist;
  final bool isMiniPlayer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(isMiniPlayer? 0 :20),
          child: CachedNetworkImage(
            imageUrl: imageURL,
            height: isMiniPlayer ? 80 : 300 ,
            width: isMiniPlayer ? 80 : 300,
            fit: BoxFit.cover,
          ),
        ),
        !isMiniPlayer
            ? Column(
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    artist,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
