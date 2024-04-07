import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../widgets/custom_bottom_bar.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Text('Health Tips screen'),
      );
  }
}
