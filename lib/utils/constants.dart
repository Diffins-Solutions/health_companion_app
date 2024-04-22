import 'package:flutter/material.dart';

const kLightGreen = Color(0xF017E5D1);
const kDarkGreen = Color(0xA0244742);
const kBackgroundColor = Color(0xFF122121);
const kBoxColor = Color(0xC71D3434);

const kHeadingSize = 30.0;
const kSubHeadingSize = 25.0;
const kNormalSize = 16.0;

const kAppNameHeading = Text(
  'FitBuddy',
  style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900),
);

const kActiveCardColor = Color(0xFF28403c);
const kInactiveCardColor = Color(0x3F28403c);
const kIconSize = 80.0;

const kIconTextStyle = TextStyle(fontSize: 18, color: Colors.white60);

const kInputDecoration = InputDecoration(
  filled: true,
  fillColor: kDarkGreen,
  labelStyle: TextStyle(color: Colors.white),
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kDarkGreen, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kDarkGreen, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);

const kNumberStyle = TextStyle(
  fontSize: 90,
  color: Colors.white,
  fontWeight: FontWeight.w900,
);

const kTimePickerTheme = ColorScheme.light(
  primary: kBackgroundColor,
);
