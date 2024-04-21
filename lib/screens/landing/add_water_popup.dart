import 'package:flutter/material.dart';
import 'package:health_companion_app/contollers/daily_target_controller.dart';
import 'package:health_companion_app/models/db_models/daily_target.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:intl/intl.dart';

addWaterPopup(BuildContext context, DailyTarget? dailyTarget) {

  TextEditingController _amountController = TextEditingController();

  void addWater () async {

    late DailyTarget newDailyTarget;
    if(dailyTarget == null){
      newDailyTarget = DailyTarget(date: DateFormat.yMMMMd().format(DateTime.now()), water: double.parse(_amountController.text));
    }else{
      double newAmount = (dailyTarget.water ?? 0) + double.parse(_amountController.text);
      newDailyTarget = DailyTarget(date: dailyTarget.date, calorie: dailyTarget.calorie, water: newAmount, steps: dailyTarget.steps);
    }
    await DailyTargetController.addOrUpdateDailyTarget(newDailyTarget);
    Navigator.pop(context);
  }
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kBackgroundColor,
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.8,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Water',
                        style: TextStyle(
                          fontSize: kSubHeadingSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        child: Icon(Icons.close),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 16),
                              SizedBox(
                                width: 80,
                                child: TextFormField(
                                  controller:
                                  _amountController,
                                  decoration: InputDecoration(
                                    hintText: 'Liters',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: TextButton(
                                onPressed: () async {
                                  if(_amountController.text.isNotEmpty){
                                    addWater();
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
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: kNormalSize,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

