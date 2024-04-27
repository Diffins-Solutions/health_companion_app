import 'package:health_companion_app/models/chart_data.dart';
import 'package:health_companion_app/models/db_models/mood_record.dart';
import 'package:health_companion_app/services/db/sqflite_handler.dart';
import 'package:intl/intl.dart';

class EmotionsController {

  /// 1. sadness => 🙁
  /// 2. joy => 😀
  /// 3. love => 🥰
  /// 4. anger => 😡
  /// 5. fear => 😰
  /// 6. surprise => 😲
  ///
  static final String _today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  static final _dbHandler = DbHandler();

  static Future<MoodRecord?> getTodayRecord(int userId) async {
    try {
      List<MoodRecord> todayRecord =
      await _dbHandler.getTodayRecord(userId);
      if (todayRecord != null && todayRecord.length >= 1) {
        return todayRecord[0];
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future addRecord(MoodRecord moodRecord) async {
    try {
      int result = await _dbHandler.insert('mood', moodRecord);
      if (result > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future updateMoodRecord(MoodRecord record) async {
    try {
      int result = await _dbHandler.update('mood', record, 'id', [record.id]);
      if (result > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static List<ChartData> convertToChartData(List<MoodRecord> moodRecords, List<String> labels) {
    // Initialize ChartData list
    List<ChartData> chartDataList = labels.map((label) => ChartData(label, 0, 0, 0, 0, 0, 0)).toList();

    for (var record in moodRecords) {
      DateTime recordDate = DateTime.parse(record.day);
      int index;
      if (labels.length == 7) { // Weekly data
        index = recordDate.weekday - 1;
      } else if (labels.length == 4) { // Monthly data
        index = ((recordDate.day - 1) / 7).floor();
      } else { // Yearly data
        index = recordDate.month - 1;
      }

      chartDataList[index].y1 += record.sadness;
      chartDataList[index].y2 += record.joy;
      chartDataList[index].y3 += record.love;
      chartDataList[index].y4 += record.anger;
      chartDataList[index].y5 += record.fear;
      chartDataList[index].y6 += record.surprise;
    }

    return chartDataList;
  }


  static Future<Map<String, List<ChartData>>> getEmotions(int userId) async {

    final List<MoodRecord> thisWeekData = await _dbHandler.getRecordsThisWeek(userId);
    final List<MoodRecord> thisMonthData = await _dbHandler.getRecordsThisWeek(userId);

    final List<MoodRecord> thisYearData = await _dbHandler.getRecordsThisWeek(userId);

    final List<ChartData> weeklyData = convertToChartData(thisWeekData, ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']);
    final List<ChartData> monthlyData = convertToChartData(thisMonthData, ['Week 1', 'Week 2', 'Week 3', 'Week 4']);
    final List<ChartData> yearlyData = convertToChartData(thisYearData, ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']);

    Map<String, List<ChartData>> emotions = Map<String, List<ChartData>>();
    emotions['weeklyData'] = weeklyData;
    emotions['monthlyData'] = monthlyData;
    emotions['yearlyData'] = yearlyData;

    return emotions;
  }

  // final List<ChartData> yearlyData = [
  //   ChartData('Jan', 10, 8, 7, 12, 24, 8),
  //   ChartData('Feb', 11, 8, 7, 12, 24, 19),
  //   ChartData('Mar', 14, 8, 7, 12, 10, 8),
  //   ChartData('Apr', 3, 8, 3, 12, 24, 3),
  //   ChartData('May', 6, 8, 7, 12, 24, 8),
  //   ChartData('Jun', 10, 6, 7, 12, 4, 8),
  //   ChartData('Jul', 14, 8, 20, 12, 24, 8),
  //   ChartData('Aug', 10, 8, 7, 4, 24, 8),
  //   ChartData('Sep', 5, 8, 7, 12, 24, 10),
  //   ChartData('Oct', 10, 8, 7, 3, 24, 8),
  //   ChartData('Nov', 15, 2, 7, 12, 24, 8),
  //   ChartData('Dec', 24, 8, 7, 12, 24, 8),
  // ];
  //
  // final List<ChartData> monthlyData = [
  //   ChartData('Week 1', 10, 8, 7, 12, 24, 8),
  //   ChartData('Week 2', 11, 8, 7, 12, 24, 19),
  //   ChartData('Week 3', 14, 8, 7, 12, 10, 8),
  //   ChartData('Week 4', 3, 8, 3, 12, 24, 3),
  // ];
  //
  // final List<ChartData> weeklyData = [
  //   ChartData('Mon', 10, 8, 7, 12, 24, 8),
  //   ChartData('Tue', 11, 8, 7, 12, 24, 19),
  //   ChartData('Wed', 14, 8, 7, 12, 10, 8),
  //   ChartData('Thu', 3, 8, 3, 12, 24, 3),
  //   ChartData('Fri', 6, 8, 7, 12, 24, 8),
  //   ChartData('Sat', 10, 6, 7, 12, 4, 8),
  //   ChartData('Sun', 14, 8, 20, 12, 24, 8),
  // ];
}