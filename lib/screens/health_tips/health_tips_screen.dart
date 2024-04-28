import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_companion_app/models/health_tips_model.dart';
import 'package:health_companion_app/services/db/fire_store_handler.dart';
import 'package:health_companion_app/utils/constants.dart';

import '../../widgets/animated_tile.dart';
import 'health_tip_widget.dart';

FireStoreHandler fireStoreHandler = FireStoreHandler();

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key, required this.healthTipsKeyWords});

  final List<String>? healthTipsKeyWords;

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> with TickerProviderStateMixin {

  List<dynamic> healthTipsGeneral = [];
  List<dynamic> healthTipsHeart = [];
  List<dynamic> healthTipsDepression = [];
  List<dynamic> healthTipsSleep = [];
  List<dynamic> healthTipsWeight = [];
  List<dynamic> healthTipsStress = [];
  List<dynamic> healthTipsOld = [];
  List<dynamic> healthTipsAnxiety = [];

  bool loading = false;
  int healthTipsArraysCount = 0 ;
  bool isOnline = false;

    HealthTipsModel healthTipsModel = HealthTipsModel();
  Future getHealthTips () async {
      List<dynamic> result = await fireStoreHandler.fetchDataWithFilter('health_tips', 'key_word', widget.healthTipsKeyWords!);
      List<dynamic> healthTips = await healthTipsModel.getHealthTips(result);
      for(var healthTip in healthTips){
        healthTipsArraysCount++;
        categorizeContent(healthTip['key_word'], healthTip['content']);
      }
      setState(() {
        loading = false;
      });


  }

  void categorizeContent (String category, dynamic content){
    switch (category){
      case 'general':
        setState(() {
          healthTipsGeneral = content;
        });
        break;
      case 'heart':
        setState(() {
          healthTipsHeart = content;
        });
        break;
      case 'depression':
        setState(() {
          healthTipsDepression = content;
        });
        break;
      case 'sleep':
        setState(() {
          healthTipsSleep = content;
        });
        break;
      case 'weight':
        setState(() {
          healthTipsWeight = content;
        });
        break;
      case 'stress':
        setState(() {
          healthTipsStress = content;
        });
        break;
      case 'anxiety':
        setState(() {
          healthTipsAnxiety = content;
        });
        break;
      case 'old':
        setState(() {
          healthTipsOld = content;
        });
        break;
    }
  }

  Future<void> hasNetwork() async {
    print('Connection check');
    try {
      final result = await InternetAddress.lookup('google.com');
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
        print('connected');
        setState(() {
          isOnline = true;
        });

      }else{
        print('Disconnected');
      }
    } on SocketException catch (_) {
      print('error connected');

    }
  }

  //animation
  late AnimationController animationController;
  late Animation<double> animation;
  int slide = 30;//by how much to slide?

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    //animation controller - this sets the timing
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    //let's give the movement some style, not linear
    animation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);

    startAnimation();
    hasNetwork().then((value) => getHealthTips());
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

    void navigateToHealthTips(List<dynamic> healthTips){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> HealthTipList(healthTips: healthTips)));
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(margin: EdgeInsets.only(bottom: 10),child: Image.asset('images/health_tips.png', width: 300,),),
            loading ? SizedBox(
              height:300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    isOnline ? Text('Loading your personalized health tips ...') : Text('Please connect to internet ...'),
                    SizedBox(height: 30,),
                    CircularProgressIndicator(color: kLightGreen,strokeAlign: CircularProgressIndicator.strokeAlignCenter,),
                  ],
                ),
              ),
            ) : ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                (healthTipsGeneral.isNotEmpty) ? AnimatedTile(slide: 30, animation: animation,child: HealthTipCard(icon: Icon(FontAwesomeIcons.asterisk, size: 40,), leftColor: Colors.indigoAccent, rightColor: Colors.indigo, title: 'General Tips', onPressed: (){navigateToHealthTips(healthTipsGeneral);},),):SizedBox(),
                (healthTipsHeart.isNotEmpty) ? AnimatedTile(slide:60, animation:animation,child: HealthTipCard(icon: Icon(FontAwesomeIcons.heartPulse, color: Colors.red, size: 40), leftColor: Colors.orangeAccent, rightColor: Colors.orange, title: 'Heart Health', onPressed: (){navigateToHealthTips(healthTipsHeart);},)):SizedBox(),
                (healthTipsDepression.isNotEmpty) ? AnimatedTile(slide:90, animation:animation,child: HealthTipCard(icon: Icon(FontAwesomeIcons.personBurst, size: 30,), leftColor: Colors.white60, rightColor: Colors.white38, title: 'Depression', onPressed: (){navigateToHealthTips(healthTipsDepression);},)):SizedBox(),
                (healthTipsOld.isNotEmpty) ?  AnimatedTile(slide:30, animation:animation,child: HealthTipCard(icon: Icon(FontAwesomeIcons.personCane, size: 40, color: Colors.brown[200],), leftColor: Colors.redAccent, rightColor: Colors.red, title: 'Old Age', onPressed: (){navigateToHealthTips(healthTipsOld);},)) : SizedBox(),
                (healthTipsSleep.isNotEmpty) ? AnimatedTile(slide:120, animation:animation, child: HealthTipCard(icon: Icon(FontAwesomeIcons.bed, size: 30,), leftColor: Colors.blueAccent, rightColor: Colors.blue, title: 'Sleep Routine', onPressed: (){navigateToHealthTips(healthTipsSleep);},)):SizedBox(),
                (healthTipsWeight.isNotEmpty) ? AnimatedTile(slide:150, animation:animation,child: HealthTipCard(icon: Icon(FontAwesomeIcons.weightScale, size: 40, color: Colors.grey,), leftColor: Colors.yellowAccent, rightColor: Colors.yellow, title: 'Weight Loss', onPressed: (){navigateToHealthTips(healthTipsWeight);},)):SizedBox(),
                (healthTipsStress.isNotEmpty) ? AnimatedTile(slide:180, animation:animation,child: HealthTipCard(icon: Icon(FontAwesomeIcons.headSideVirus, size: 40, color: Colors.brown,), leftColor: Colors.greenAccent, rightColor: Colors.green, title: 'Stress Management', onPressed: (){navigateToHealthTips(healthTipsStress);},)):SizedBox(),
                (healthTipsAnxiety.isNotEmpty) ? AnimatedTile(slide:210, animation:animation,child: HealthTipCard(icon: Icon(Icons.face_retouching_natural, size: 40,), leftColor: Colors.purpleAccent, rightColor: Colors.purple, title: 'Anxiety', onPressed: (){navigateToHealthTips(healthTipsAnxiety);},)):SizedBox(),
              ],
            ),
            SizedBox(height: 60,)
          ],
        ),
      ),
    );
  }
}

class HealthTipCard extends StatelessWidget {

  final Icon icon;
  final Color leftColor;
  final Color rightColor;
  final String title;
  final VoidCallback onPressed;

  const HealthTipCard({
    required this.icon, required this.leftColor, required this.rightColor, required this.title, required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Material(
        child: MaterialButton(
          elevation: 10,
          onPressed: onPressed,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: leftColor,),

                  height:70,
                  child: icon,
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration( color: rightColor,),
                  height: 70,
                  child: Text(title, style: TextStyle(fontSize: kSubHeadingSize)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

