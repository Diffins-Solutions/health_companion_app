import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_companion_app/models/local_notifications.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:intl/intl.dart';
import '../../widgets/welcome_text.dart';
import '../../models/reminder.dart';

class MedicationScreen extends StatefulWidget {
  String formattedDate = DateFormat.yMMMMd().format(DateTime.now());
  MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  TimeOfDay? _time;
  DateTime? _date;
  bool _repeat = false;
  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  List<PendingNotificationRequest> reminders = [];

  Future<void> getPendingRequests() async {
    List<PendingNotificationRequest> pendingRequests =
        await LocalNotifications.getPending();
    setState(() {
      reminders = pendingRequests;
    });
  }

  String getDateForReminder(PendingNotificationRequest reminder) {
    String dateTime = '';
    if(reminder?.payload != 'Repeat' && reminder?.body != ''){
      dateTime = reminder?.body ?? DateTime.now().toString();
    }else{
      dateTime = getDateForRepeatReminder(reminder?.body ?? DateTime.now().toString());
    }
    return dateTime;
  }

  String getDateForRepeatReminder(String dateTime) {
    DateTime _dateTime = DateTime.parse(dateTime);
    if (DateTime.now().isAfter(_dateTime)) {
      _dateTime = _dateTime.add(Duration(days: 1));
    }
    return _dateTime.toString();
  }

  @override
  void initState() {
    super.initState();
    getPendingRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  SizedBox(height: 14),
                  TextFormField(
                    controller: _medicineController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      hintText: 'Medicine',
                      hintStyle: TextStyle(
                        fontSize: kNormalSize,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  InkWell(
                    child: IgnorePointer(
                      ignoring: true,
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          hintText: 'Date',
                          hintStyle: TextStyle(
                            fontSize: kNormalSize,
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                        initialDate: DateTime.now(),
                        context: context,
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light()
                                .copyWith(colorScheme: kTimePickerTheme),
                            child: child!,
                          );
                        },
                      );

                      if (selectedDate != null) {
                        setState(() {
                          _date = selectedDate;
                          _dateController.text =
                              DateFormat('dd/MM/yyyy').format(_date!);
                        });
                      }
                    },
                  ),
                  SizedBox(height: 12),
                  InkWell(
                    child: IgnorePointer(
                      ignoring: true,
                      child: TextFormField(
                        controller: _timeController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          hintText: 'Time',
                          hintStyle: TextStyle(
                            fontSize: kNormalSize,
                          ),
                           ),
                      ),
                    ),
                    onTap: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light()
                                .copyWith(colorScheme: kTimePickerTheme),
                            child: child!,
                          );
                        },
                      );

                      if (selectedTime != null) {
                        setState(() {
                          _time = selectedTime;
                          final now = DateTime.now();
                          final time = DateTime(now.year, now.month, now.day,
                              _time!.hour, _time!.minute);
                          _timeController.text =
                              DateFormat('hh:mm a').format(time);
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Repeat reminder daily',
                        style: TextStyle(
                          fontSize: kNormalSize,
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          activeColor: Color(0xff16D9C6),
                          value: _repeat,
                          onChanged: (val) => setState(() {
                            _repeat = val;
                          }),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        if (_medicineController.text != '' &&
                            _time != null &&
                            _date != null) {
                          DateTime dateTime = DateTime(
                              _date!.year,
                              _date!.month,
                              _date!.day,
                              _time!.hour,
                              _time!.minute);
                          if(DateTime.now().isAfter(dateTime)){
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Input Future time of the day !', style: TextStyle(color: Colors.red),)));
                            return;
                          }
                          Random random = Random();
                          int randomNumber = random.nextInt(1000) + 1;
                          final reminder = Reminder(
                              id: randomNumber,
                              title: _medicineController.text,
                              dateTime: dateTime.toString(),
                              repeat: _repeat);

                          if (_repeat) {
                            await LocalNotifications
                                .showScheduledNotificationDaily(
                                    title: reminder.title,
                                    body: dateTime.toString(),
                                    payload: "Repeat",
                                    dateTime: dateTime,
                                    id: reminder.id);
                          } else {
                            await LocalNotifications
                                .showScheduledNotification(
                                    title: reminder.title,
                                    body: dateTime.toString(),
                                    payload: "No-Repeat",
                                    dateTime: dateTime,
                                    id: reminder.id);
                          }
                          List<PendingNotificationRequest> pendingReminders =
                              await LocalNotifications.getPending();
                          setState(() {
                            reminders = pendingReminders;
                            _medicineController.clear();
                            _timeController.clear();
                            _dateController.clear();
                            _repeat = false;
                          });

                          //await LocalNotifications.getActive();
                          //await LocalNotifications.cancelAllNotifications();
                          //print("After");
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        backgroundColor: Color(0xff16D9C6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: kNormalSize,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 40,
                    thickness: 2,
                    color: Color(0xff334E4B),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Dismissible(
                          direction: DismissDirection.endToStart,
                          key: Key(reminders[index].id.toString()),
                          onDismissed: (direction) async {
                            // Get the id of the dismissed item
                            final id = reminders[index].id;

                            // Cancel notification and delete reminder using the id
                            await LocalNotifications.cancelNotification(id);
                            List<PendingNotificationRequest>
                                pendingReminders =
                                await LocalNotifications.getPending();
                            // Update the UI using setState
                            setState(() {
                              reminders = pendingReminders;
                            });
                          },
                          background: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff334E4B),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xff182A2B),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reminders[index]?.title ?? 'No title',
                                        style: TextStyle(
                                          fontSize: kNormalSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        reminders[index]?.payload ??
                                            'Undefined',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(DateTime.parse(getDateForReminder(reminders[index]))),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff77B2B6),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      DateFormat('HH:mm a').format(
                                          DateTime.parse(
                                              reminders[index]?.body ??
                                                  DateTime.now().toString())),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff77B2B6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
