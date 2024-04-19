import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MediaMetaData extends StatelessWidget {
  const MediaMetaData(
      {super.key,
        required this.imageURL,
        required this.title,
        required this.artist});

  final String imageURL;
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: imageURL,
            height: 300,
            width: 300,
            fit: BoxFit.cover,
          ),
        ),
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
    );
  }
}