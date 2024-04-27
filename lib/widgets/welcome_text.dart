import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/profile/profile_screen.dart';
import 'package:health_companion_app/utils/constants.dart';

import 'package:health_companion_app/screens/health_tips/quessionaire_screen.dart';

class WelcomeText extends StatelessWidget {
  final String name;
  final String today;
  final bool isLandingPage;
  final bool isMoodPage;

  WelcomeText({required this.name, required this.today, required this.isLandingPage, required this.isMoodPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi ${name}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(
                today,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          isLandingPage ?
          CircleAvatar(
            backgroundColor: kActiveCardColor,
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                icon: Icon(Icons.person),),
          )
          : isMoodPage ?
          CircleAvatar(
            backgroundColor: kActiveCardColor,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuessionaireScreen()
                  ),
                );
              },
              icon: Icon(Icons.question_mark_outlined),),
          )
          :
          Container()
        ],
      ),
    );
  }
}
