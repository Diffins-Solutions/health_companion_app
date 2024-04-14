import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/profile/profile_screen.dart';

class WelcomeText extends StatelessWidget {
  final String name;
  final String today;

  WelcomeText({required this.name, required this.today});

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
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              Text(
                today,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
