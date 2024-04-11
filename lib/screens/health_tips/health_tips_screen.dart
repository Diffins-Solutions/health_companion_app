import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_companion_app/utils/constants.dart';

import '../../models/health_tip.dart';
import 'health_tip_widget.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  List<HealthTip> healthTips = [
    HealthTip(
        id: 'id',
        title: 'The Basics: What Is Heart Disease?',
        content:
            "<p>When people talk about heart disease, they’re usually talking about coronary heart disease (CHD). It’s also sometimes called coronary artery disease (CAD). This is the most common type of heart disease.&nbsp;</p>\r\n\r\n<p>When someone has CHD, the coronary arteries (tubes) that take blood to the heart are narrow or blocked. This happens when cholesterol and fatty material, called plaque, build up inside the arteries.&nbsp;</p>\r\n\r\n<p>Several things can lead to plaque building up inside your arteries,&nbsp;including:</p>\r\n\r\n<ul>\r\n\t<li>Too much&nbsp;cholesterol in the blood&nbsp;</li>\r\n\t<li>High blood pressure&nbsp;</li>\r\n\t<li>Smoking&nbsp;</li>\r\n\t<li>Too much sugar in the blood because of diabetes</li>\r\n</ul>\r\n\r\n<p>When plaque blocks an artery, it’s hard for blood to flow to the heart. A blocked artery can cause chest pain or a heart attack. <a href=\"https://health.gov/myhealthfinder/api/outlink/topicsearch.json/http/www.nhlbi.nih.gov/health/health-topics/topics/cad/?_label_=Learn+more+about+CHD\">Learn more about CHD</a>.&nbsp;</p>\r\n"),
    HealthTip(
        id: '2345',
        title: 'Take Action: Signs of a Heart Attack',
        content:
            "<h4>What is a heart attack?</h4>\r\n\r\n<p>A heart attack happens when blood flow to the heart is suddenly blocked. Part of the heart may die if the person doesn’t get help quickly.&nbsp;</p>\r\n\r\n<p>Some common signs and symptoms of a heart attack include:&nbsp;</p>\r\n\r\n<ul>\r\n\t<li>Pain or discomfort in the center or left side of the chest — or a feeling of pressure, squeezing, or fullness&nbsp;</li>\r\n\t<li>Pain or discomfort in the upper body — like the arms, back, shoulders, neck, jaw, or upper stomach (above the belly button)&nbsp;</li>\r\n\t<li>Shortness of breath or trouble breathing (while resting or being active)&nbsp;</li>\r\n\t<li>Feeling sick to your stomach or throwing up&nbsp;</li>\r\n\t<li>Stomach ache or feeling like you have heartburn &nbsp;</li>\r\n\t<li>Feeling dizzy, light-headed, or unusually tired&nbsp;</li>\r\n\t<li>Breaking out in a cold sweat&nbsp;</li>\r\n</ul>\r\n\r\n<p>Not everyone who has a heart attack will have all the signs or symptoms. <a href=\"https://health.gov/myhealthfinder/api/outlink/topicsearch.json/http/www.nhlbi.nih.gov/health/health-topics/topics/heartattack/?_label_=Learn+more+about+the+signs+of+a+heart+attack\">Learn more about the signs of a heart attack</a>.&nbsp;</p>\r\n\r\n<h4>Don’t ignore changes in how you feel.</h4>\r\n\r\n<p><span><span>Symptoms&nbsp;</span></span>of a heart attack often come on suddenly. But sometimes, they develop slowly — hours, days, or even weeks before a heart attack happens.&nbsp;</p>\r\n\r\n<p>Talk to your doctor if you feel unusually tired for several days, or if you develop any new health problems (like pain or trouble breathing). It's also important to talk to your doctor if existing health issues (like pain) are bothering you more than usual.&nbsp;</p>\r\n\r\n<p>If you’ve had a heart attack in the past, it’s important to know that symptoms of a new heart attack might be different from your last one — so talk with your doctor if you have any concerns about how you feel. &nbsp;</p>\r\n"),
  ];


  @override
  Widget build(BuildContext context) {

    void navigateToHealthTips(List<HealthTip> healthTips){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> HealthTipList(healthTips: healthTips)));
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('images/health_tips.png'),
            HealthTipCard(icon: Icon(FontAwesomeIcons.asterisk, size: 60,), leftColor: Colors.indigoAccent, rightColor: Colors.indigo, title: 'General Tips', onPressed: (){navigateToHealthTips(healthTips);},),
            HealthTipCard(icon: Icon(FontAwesomeIcons.heartPulse, color: Colors.red, size: 60), leftColor: Colors.orangeAccent, rightColor: Colors.orange, title: 'Heart Health', onPressed: (){navigateToHealthTips(healthTips);},),
            HealthTipCard(icon: Icon(FontAwesomeIcons.personBurst, size: 50,), leftColor: Colors.white60, rightColor: Colors.white38, title: 'Depression', onPressed: (){navigateToHealthTips(healthTips);},),
            HealthTipCard(icon: Icon(FontAwesomeIcons.personCane, size: 60, color: Colors.brown[200],), leftColor: Colors.redAccent, rightColor: Colors.red, title: 'Old Age', onPressed: (){navigateToHealthTips(healthTips);},),
            HealthTipCard(icon: Icon(FontAwesomeIcons.bed, size: 50,), leftColor: Colors.blueAccent, rightColor: Colors.blue, title: 'Sleep Routine', onPressed: (){navigateToHealthTips(healthTips);},),
            HealthTipCard(icon: Icon(FontAwesomeIcons.weightScale, size: 60, color: Colors.grey,), leftColor: Colors.yellowAccent, rightColor: Colors.yellow, title: 'Weight Loss', onPressed: (){navigateToHealthTips(healthTips);},),
            HealthTipCard(icon: Icon(FontAwesomeIcons.headSideVirus, size: 60, color: Colors.brown,), leftColor: Colors.greenAccent, rightColor: Colors.green, title: 'Stress Management', onPressed: (){navigateToHealthTips(healthTips);},),
            HealthTipCard(icon: Icon(Icons.face_retouching_natural, size: 60,), leftColor: Colors.purpleAccent, rightColor: Colors.purple, title: 'Anxiety', onPressed: (){navigateToHealthTips(healthTips);},),
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
      padding: const EdgeInsets.only(top: 15),
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25),), color: leftColor,),

                  height:100,
                  child: icon,
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25),), color: rightColor,),
                  height: 100,
                  child: Text(title, style: TextStyle(fontSize: kHeadingSize), textAlign: TextAlign.center,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
