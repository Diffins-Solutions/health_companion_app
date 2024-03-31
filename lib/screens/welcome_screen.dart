import 'package:flutter/material.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/widgets/custom_flat_button.dart';

import '../widgets/custom_round_button.dart';


class WelcomeScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      children: [
        Text('My Health Companion'),
        CustomFlatButton(label: 'Custom Button', color: kLightGreen, onPressed: (){}),
        CustomFlatButton(label: 'Custom Button', color: kLightGreen, onPressed: (){}, icon: Icons.navigate_next_sharp,),
        CustomRoundButton(label: 'Custom Button', color: kLightGreen, onPressed: (){}, icon: Icons.navigate_next_sharp, isSmall: true,),
        CustomRoundButton(label: 'Custom Button', color: kDarkGreen, onPressed: (){}, icon: Icons.navigate_next_sharp, isSmall: true,),
        CustomRoundButton(label: 'Custom Button', color: kLightGreen, onPressed: (){}, icon: Icons.navigate_next_sharp, isSmall: false,),
      ],
    ));
  }
}
