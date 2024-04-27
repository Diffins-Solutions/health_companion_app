import 'package:flutter/material.dart';
import 'package:health_companion_app/contollers/emotions_controller.dart';
import 'package:health_companion_app/contollers/user_controller.dart';
import 'package:health_companion_app/models/db_models/mood_record.dart';
import 'package:health_companion_app/models/db_models/user.dart';
import 'package:health_companion_app/services/mood/mood_service.dart';
import 'package:health_companion_app/widgets/chart_section.dart';
import 'package:health_companion_app/widgets/input_emotion.dart';
import 'package:health_companion_app/widgets/welcome_text.dart';
import 'package:intl/intl.dart';

import '../../models/chart_data.dart';

/// 1. sadness => 🙁
/// 2. joy => 😀
/// 3. love => 🥰
/// 4. anger => 😡
/// 5. fear => 😰
/// 6. surprise => 😲
///


class MoodScreen extends StatefulWidget {
  String formattedDate = DateFormat.yMMMMd().format(DateTime.now());

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen>
    with SingleTickerProviderStateMixin {

  final TextEditingController _textController = TextEditingController();
  late final TabController _tabController;
  String name = '';
  int? userId;
  List<ChartData> monthlyData = [];
  List<ChartData> weeklyData = [];
  List<ChartData> yearlyData = [];

  Future<User> getUser() async {
    User user = await UserController.getUser();
    if (user != null) {

      MoodRecord? todayRec = await EmotionsController.getTodayRecord(user.id!);
      if(todayRec == null){
        todayRec = MoodRecord(day: DateFormat('yyyy-MM-dd').format(DateTime.now()), sadness: 0, joy: 0, love: 0, anger: 0, fear: 0, surprise: 0, userId: user.id!);
        bool res = await EmotionsController.addRecord(todayRec);
        if(res){
          todayRec = await EmotionsController.getTodayRecord(user.id!);
          if(todayRec != null){
            await getEmotions(user.id!);
          }
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Something went wrong! Can not load previous records!')));
        }
      }else{
        await getEmotions(user.id!);
      }

      setState(() {
        this.name = user.name;
        this.userId = user.id;
      });
    }
    return user;
  }

  Future<Map<String, List<ChartData>>> getEmotions(int userId) async {
    Map<String, List<ChartData>> emotions = await EmotionsController.getEmotions(userId);
    if (emotions != null){
      this.weeklyData = emotions['weeklyData']!;
      this.monthlyData = emotions['monthlyData']!;
      this.yearlyData = emotions['yearlyData']!;
    }
    return emotions;
  }

  void sendEmotion(String log) async{
    String? mood = await getMood(log);
    if(mood != null && userId != null){
      MoodRecord? todayRec = await EmotionsController.getTodayRecord(userId!);
      if(todayRec != null){
        todayRec.increaseMood(mood);
      }else{
        todayRec = MoodRecord(day: DateFormat('yyyy-MM-dd').format(DateTime.now()), sadness: 0, joy: 0, love: 0, anger: 0, fear: 0, surprise: 0, userId: userId!);
        bool res = await EmotionsController.addRecord(todayRec);
        if(!res){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Something went wrong! check your internet connection!')));
          return;
        }else{
          todayRec.increaseMood(mood);
        }
      }
      bool res = await EmotionsController.updateMoodRecord(todayRec);
      await getEmotions(userId!);
      setState(() {

      });

      if(!res){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Something went wrong! check your internet connection!')));
      }

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong! check your internet connection!')));
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          WelcomeText(name: name, today: widget.formattedDate),
          Expanded(
              flex: 2,
              child: FutureBuilder(
                future: userId == null ? Future.value(null) : getEmotions(userId!),
                  builder: (BuildContext context, AsyncSnapshot<Map<String, List<ChartData>>?> snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                    return Center(child: CircularProgressIndicator()); // Show a loading spinner while waiting
                    } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Show error message if any error occurred
                    } else {
                    return ChartSection(tabController: _tabController, weeklyData: weeklyData, monthlyData: monthlyData, yearlyData: yearlyData,);
                    }},
                  )),
          Expanded(child: InputEmotion(textController: _textController, sendEmotion: sendEmotion)),
        ],
      ),
    );
  }
}
