import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomInputField extends StatelessWidget {
  final void Function(dynamic) onChange;
  final String hint;
  TextInputType ?textInputType = TextInputType.text;
  bool isPassword ;

  CustomInputField({required this.onChange, required this.hint, this.textInputType, this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        textAlign: TextAlign.center,
        obscureText: isPassword,
        keyboardType: textInputType,
        onChanged: (value) {
          onChange(value);
        },
        decoration: kInputDecoration.copyWith(hintText: hint),
      ),
    );
  }
}
