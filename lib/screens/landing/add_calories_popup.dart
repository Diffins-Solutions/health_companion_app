import 'package:flutter/material.dart';
import 'package:health_companion_app/contollers/daily_target_controller.dart';
import 'package:health_companion_app/models/db_models/daily_target.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/db_models/food_calorie.dart';

addCaloriesPopup(BuildContext context, List<String> food, List<FoodCalorie> foodCalories, DailyTarget? dailyTarget) {
  String? _selectedFood;

  TextEditingController _foodContoller = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  void addCalorie () async {
    //TODO: add
    double calculatedCalorie = 0.0 ;
    print('foods ${foodCalories.length}');
    for(FoodCalorie item in foodCalories) {
      if(item.food == _selectedFood){
        print('found');
        calculatedCalorie = (item.calorie/100)*int.parse(_amountController.text);
        break;
      }
    }
    late DailyTarget newDailyTarget;
    if(dailyTarget == null){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int user_id = prefs.getString('user_id') as int;
      newDailyTarget = DailyTarget(date: DateFormat.yMMMMd().format(DateTime.now()), calorie: calculatedCalorie, userId: user_id);
    }else{

      double newAmount = (dailyTarget.calorie ?? 0) + calculatedCalorie;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getString('user_id') as int;
      newDailyTarget = DailyTarget(date: dailyTarget.date, calorie: newAmount, water: dailyTarget.water, steps: dailyTarget.steps, userId: userId);
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
                        'Add Calories',
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
                              children: [
                                Flexible(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: Text(
                                        'Select Item',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                      items: food
                                          .map((item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                          .toList(),
                                      value: _selectedFood,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFood = value;
                                        });
                                      },
                                      buttonStyleData: const ButtonStyleData(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        height: 40,
                                        width: 200,
                                      ),
                                      dropdownStyleData: const DropdownStyleData(
                                        maxHeight: 200,
                                      ),
                                      menuItemStyleData: const MenuItemStyleData(
                                        height: 40,
                                      ),
                                      dropdownSearchData: DropdownSearchData(
                                        searchController: _foodContoller,
                                        searchInnerWidgetHeight: 50,
                                        searchInnerWidget: Container(
                                          height: 50,
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 4,
                                            right: 8,
                                            left: 8,
                                          ),
                                          child: TextFormField(
                                            expands: true,
                                            maxLines: null,
                                            controller: _foodContoller,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                              hintText: 'Search for an item...',
                                              hintStyle: const TextStyle(fontSize: 12),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        searchMatchFn: (item, searchValue) {
                                          return item.value.toString().toLowerCase().contains(searchValue);
                                        },
                                      ),
                                      //This to clear the search value when you close the menu
                                      onMenuStateChange: (isOpen) {
                                        if (!isOpen) {
                                          _foodContoller.clear();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                SizedBox(
                                  width: 80,
                                  child: TextFormField(
                                    controller:
                                        _amountController,
                                    decoration: InputDecoration(
                                      hintText: 'Gram',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 14),
                        Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: TextButton(
                                onPressed: () async {
                                  if(_selectedFood!= null && _selectedFood!.isNotEmpty && _amountController.text.isNotEmpty){
                                    addCalorie();
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

