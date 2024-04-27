import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> getMood(String log) async {
  var url = Uri.parse('http://10.0.2.2:8000/mood/get_mood/');
  var response = await http.post(url, body: {'log': log});

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    String mood = jsonResponse['mood'];
    return mood;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  return null;
}


