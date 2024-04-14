import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:intl/intl.dart';

import '../../widgets/welcome_text.dart';

class MedicationScreen extends StatefulWidget {
  final String name = 'Nethmi';
  String formattedDate = DateFormat.yMMMMd().format(DateTime.now());
  MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  TimeOfDay? _time;
  DateTime? _date;
  bool _repeat = false;
  TextEditingController _timeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              WelcomeText(name: widget.name, today: widget.formattedDate),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    SizedBox(height: 14),
                    TextFormField(
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
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Repeat reminder',
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
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          setState(() {});
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
                      itemCount: 50,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Dismissible(
                            direction: DismissDirection.endToStart,
                            key: Key(index.toString()),
                            onDismissed: (direction) {},
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
                                          'Notification title',
                                          style: TextStyle(
                                            fontSize: kNormalSize,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Notification description',
                                          style: TextStyle(
                                            fontSize: 14,
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
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff77B2B6),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        DateFormat('HH:mm a')
                                            .format(DateTime.now()),
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
      ),
    );
  }
}
