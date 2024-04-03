import 'package:flutter/material.dart';
import '../utils/constants.dart';


class IconContent extends StatelessWidget {

  final IconData iconData;
  final String iconText;

  IconContent(this.iconData, this.iconText);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData, size: kIconSize,),
        SizedBox(
          height: 15,
        ),
        Text(
          iconText,
          style: kIconTextStyle
        )
      ],
    );
  }
}
