import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Color color;
  final Widget cardChild;
  final VoidCallback onPress;

  CustomCard({required this.color, required this.cardChild, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: cardChild,
      ),
    );
  }
}