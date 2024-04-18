import 'package:flutter/material.dart';
import 'package:health_companion_app/utils/constants.dart';

addCaloriesPopup(BuildContext context) {
  List<String> food = [
    'White Rice',
    'Chicken',
    'Carrot',
  ];
  List<Map<String, String>> foodCount = [];
  String? _selectedDrowdown;
  TextEditingController _controller = TextEditingController();

  return showDialog(
    // TODO: Handle previous calorie data
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
                        for (int i = 0; i < (foodCount.length + 1); i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Flexible(
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Select food',
                                    ),
                                    items: food.map((e) {
                                      return DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      );
                                    }).toList(),
                                    value: foodCount.elementAtOrNull(i) == null
                                        ? _selectedDrowdown
                                        : foodCount[i]['food'],
                                    onChanged: (val) {
                                      _selectedDrowdown = val;
                                    },
                                  ),
                                ),
                                SizedBox(width: 16),
                                SizedBox(
                                  width: 80,
                                  child: TextFormField(
                                    controller:
                                        foodCount.elementAtOrNull(i) == null
                                            ? _controller
                                            : TextEditingController(
                                                text: foodCount[i]['grams'],
                                              ),
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
                            SizedBox(width: 16),
                            SizedBox(
                              width: 80,
                              child: TextButton(
                                onPressed: () {
                                  if (_selectedDrowdown != null &&
                                      _controller.text.isNotEmpty) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {
                                      foodCount.add({
                                        'food': _selectedDrowdown!,
                                        'grams': _controller.text,
                                      });
                                      _controller.clear();
                                      _selectedDrowdown = null;
                                    });
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
                                child: Icon(
                                  Icons.add,
                                  color: Colors.black,
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
