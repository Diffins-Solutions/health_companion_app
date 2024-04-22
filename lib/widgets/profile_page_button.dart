import 'package:flutter/material.dart';
import 'package:health_companion_app/utils/constants.dart';

class ProfilePageButton extends StatelessWidget {

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const ProfilePageButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: Colors.white),
          SizedBox(width: 10,),
          Text('$label', style: TextStyle(color: Colors.white)),
        ],
      ),
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

