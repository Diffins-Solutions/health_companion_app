import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_companion_app/utils/constants.dart';

class ProfileDetailBox extends StatelessWidget {

  final String title;
  final dynamic value;
  final bool editMode;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final int minLimit;
  final int maxLimit;
  const ProfileDetailBox({
    super.key,
    required this.title,
    required this.value,
    required this.editMode,
    required this.onIncrease,
    required this.onDecrease,
    required this.minLimit,
    required this.maxLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        color: kBoxColor,
        border: Border.all(
            width: 2,
            color: Colors.white
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: editMode ? MainAxisAlignment.spaceAround: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Center(child: Text('$title', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w500, color: Colors.white),)),
                    Center(child: Text(value != null ? value.toString() : 'N/A', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.grey),)),
                  ],
                ),
                editMode ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: onIncrease,
                        splashColor: kLightGreen,
                        child: Icon(Icons.arrow_upward, size: 40,color: value is int && value != null && value! >= maxLimit ? Colors.grey: Colors.white,)),
                    InkWell(
                        onTap: onDecrease,
                        splashColor: kLightGreen,
                        child: Icon(Icons.arrow_downward,size: 40, color: value is int && value != null && value! <= minLimit ? Colors.grey: Colors.white,)),
                  ],
                ):
                SizedBox(width: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
