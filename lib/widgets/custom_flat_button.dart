import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomFlatButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  IconData ?icon;

  CustomFlatButton(
      {required this.label, required this.color, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: double.infinity,
          height: 65.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 25,
                    color: color != kLightGreen ? Colors.white: Colors.black,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1),
              ),
              if (icon != null) SizedBox(width: 30,),
            if (icon != null) Icon(icon, color: color != kLightGreen ? Colors.white: Colors.black, size: 35,),
            ],
          ),
        ),
      ),
    );
  }
}
