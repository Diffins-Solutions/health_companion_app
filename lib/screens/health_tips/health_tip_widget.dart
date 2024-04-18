import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_companion_app/widgets/animated_tile.dart';
import '../../models/health_tip.dart';
import '../../utils/constants.dart';

class HealthTipList extends StatefulWidget {
  const HealthTipList({super.key, required this.healthTips});
  final List<dynamic> healthTips;

  @override
  State<HealthTipList> createState() => _HealthTipListState();
}


class _HealthTipListState extends State<HealthTipList>  with TickerProviderStateMixin{
  //animation
  late AnimationController animationController;
  late Animation<double> animation;
  int slide = 30;//by how much to slide?

  @override
  void initState() {
    //animation controller - this sets the timing
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    //let's give the movement some style, not linear
    animation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);

    startAnimation();
    super.initState();
  }

  void startAnimation() {
    //if you want to call it again, e.g. after pushing and popping
    //a screen, you will need to reset to 0. Otherwise won't work.
    animationController.value = 0;
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(backgroundColor: kBackgroundColor,),
      body: SafeArea(
        child: ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: widget.healthTips.length,
          itemBuilder: (context, index) {
            final healthTip = widget.healthTips[index];
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
                tag: index + 1000, // Unique identifier for the animation
                child: AnimatedTile(slide:30 + 30*index, animation:animation,child: _HealthTipListItem(healthTip: healthTip)),
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

  final dynamic healthTip;

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
            healthTip['Title'] ?? '',
            style: TextStyle(fontWeight: FontWeight.w900,),
          ),
        ],
      ),
    );
  }
}

class HealthContentDetail extends StatelessWidget {
  const HealthContentDetail({required this.healthTip});

  final dynamic healthTip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Text(healthTip['Title']),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: HtmlWidget(healthTip['Content']),
          ),
        ),
      ),
    );
  }
}



