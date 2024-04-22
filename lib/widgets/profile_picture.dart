import 'package:flutter/material.dart';
import 'package:health_companion_app/utils/constants.dart';

class ProfilePicture extends StatelessWidget {

  const ProfilePicture({super.key, required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kLightGreen,
          shape: BoxShape.circle,
          border: Border.all(
              color: kActiveCardColor,
              width: 3
          )
      ),
      child: ClipOval(
          child: Image.asset(
            '$address',
            height: 200,
            width: 200,
            fit: BoxFit.cover,)
      ),
    );
  }
}
