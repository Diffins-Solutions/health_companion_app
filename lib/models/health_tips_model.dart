import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_companion_app/services/api/networking.dart';

import 'db_models/user.dart';

class HealthTipsModel {
  List<dynamic> healthTips = [];

  Future getHealthTips(List<dynamic> idMaps) async {
    var i = 0;
    for (var idMap in idMaps) {

      healthTips.add({'key_word': idMap['key_word'], 'content': []});
      for (var id in idMap['tips']) {
        NetworkHelper networkHelper = NetworkHelper(Uri.parse(
            'https://health.gov/myhealthfinder/api/v3/topicsearch.json?TopicId=$id'));
        var decodedData = await networkHelper.getData();
        List<dynamic> cleanedList = cleanList(decodedData.data['Result']
        ['Resources']['Resource'][0]['Sections']['section']);
        healthTips[i]['content'].addAll(cleanedList);
      }
      i++;
    }
    return healthTips;
  }

  static List<String> getRecomendedHealthTips(User user, int sleep) {
    List<String> currentRecommendations = [];
    double bmi = user.weight / pow(user.height, 2);

    if (user.age >= 50) {
      currentRecommendations.add("old");
    }
    if (user.age >= 20 && bmi > 25){
      currentRecommendations.add("weight");
    } else if (user.age < 20 && bmi > 85){
      currentRecommendations.add("weight");
    }
    if (user.heart != null) {
      if ((user.age > 20 && user.age < 64) && (user.heart! < 60 && user.heart! > 100)) {
        currentRecommendations.add("heart");
      } else if ( user.age > 65 && (user.heart! < 60 && user.heart! > 90)) {
        currentRecommendations.add("heart");
      }
    }
    if (user.age >= 18 && sleep < 7) {
      currentRecommendations.add("sleep");
    } else if (user.age >= 13 && sleep < 8) {
      currentRecommendations.add("sleep");
    }
    return currentRecommendations;
  }

  List<dynamic> cleanList (List<dynamic> inputList) {
    List<dynamic> outputList = [];
    for(var item in inputList){
      if(item['Title'] != null){
        outputList.add(item);
      }
    }
    return outputList;
  }
}
