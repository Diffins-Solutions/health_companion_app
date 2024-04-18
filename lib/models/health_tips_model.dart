import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_companion_app/services/api/networking.dart';

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
        // print(decodedData
        //     .data['Result']['Resources']['Resource'][0]['Sections']['section']
        //     .length);
      }
      print(healthTips[i]['content'].length);
      i++;
      //Result.Resources.Resource[0].Sections.section
    }
    return healthTips;

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
