import 'package:flutter/material.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class CustomBottomBar extends StatefulWidget {
  final Color color = Colors.white;
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDarkGreen,
      padding: EdgeInsets.all(12.0),
      child: SalomonBottomBar(
        currentIndex: widget.currentIndex,
        selectedItemColor: widget.color,
        onTap: widget.onTap,
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.mood),
            title: Text("Mood"),
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.tips_and_updates),
            title: Text("Health Tips"),
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.medical_information),
            title: Text("Medication"),
          ),
        ],
      ),
    );
  }
}
