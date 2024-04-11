import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/health_tip.dart';
import '../../utils/constants.dart';

class HealthTipList extends StatelessWidget {
  const HealthTipList({super.key, required this.healthTips});

  final List<HealthTip> healthTips;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(backgroundColor: kBackgroundColor,),
      body: SafeArea(
        child: ListView.builder(
          itemCount: healthTips.length,
          itemBuilder: (context, index) {
            final healthTip = healthTips[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HealthContentDetail(healthTip: healthTip),
                    fullscreenDialog:
                        true, // Simulate container transform effect
                  ),
                );
              },
              child: Hero(
                tag: healthTip.id, // Unique identifier for the animation
                child: _HealthTipListItem(healthTip: healthTip),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HealthTipListItem extends StatelessWidget {
  const _HealthTipListItem({required this.healthTip});

  final HealthTip healthTip;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: kActiveCardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Colors.white10,
                blurRadius: 10,
                blurStyle: BlurStyle.outer)
          ]),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.featherPointed, size: 15, color: Colors.greenAccent,),
          SizedBox(width: 10,),
          Text(

            healthTip.title,
            style: TextStyle(fontWeight: FontWeight.w900,),
          ),
        ],
      ),
    );
  }
}

class HealthContentDetail extends StatelessWidget {
  const HealthContentDetail({required this.healthTip});

  final HealthTip healthTip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Text(healthTip.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: HtmlWidget(healthTip.content),
          ),
        ),
      ),
    );
  }
}
