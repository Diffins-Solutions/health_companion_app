import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomRoundButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool isSmall;
  IconData ?icon;

  CustomRoundButton(
      {required this.label, required this.color, required this.onPressed, required this.isSmall, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        elevation: 8,
        borderRadius: isSmall?BorderRadius.circular(12.0):BorderRadius.circular(24.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: (isSmall)? 180:360,
          height: 48.0,
          child: Text(
            label,
            style: TextStyle(
                fontSize: 16,
                color: color != kLightGreen ? Colors.white: Colors.black,
                fontWeight: FontWeight.w900,
                letterSpacing: 1),
          ),
        ),
      ),
    );
  }
}
