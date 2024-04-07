import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class CustomBottomBar extends StatefulWidget {
  final Color color = Colors.white;
  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: kDarkGreen,
        padding: EdgeInsets.all(12.0),
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          selectedItemColor: widget.color,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: Icon(Icons.directions_walk),
              title: Text("Activity"),
            ),

            /// Search
            SalomonBottomBarItem(
              icon: Icon(Icons.tips_and_updates),
              title: Text("Health Tips"),
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
            ),
          ],
        ),
      );
  }
}
