import 'package:flutter/material.dart';
import 'package:health_companion_app/utils/constants.dart';

class InputEmotion extends StatefulWidget {

  const InputEmotion({
    super.key,
    required TextEditingController textController,
    required this.sendEmotion,
  }) : _textController = textController;

  final Function(String) sendEmotion;
  final TextEditingController _textController;

  @override
  State<InputEmotion> createState() => _InputEmotionState();
}

class _InputEmotionState extends State<InputEmotion> {
  
  final _formkey = GlobalKey<FormState>();

  String? textValidator(value){
    if(value == null || value.isEmpty){
      return 'Oops! text can\'t be empty';
    }else if (value.length < 10) {
      return 'Please enter at least 10 characters';
    }
    return null;
  }

  void onPressed() {
    if(_formkey.currentState!.validate()){
      widget.sendEmotion(widget._textController.text);
      setState(() {
        widget._textController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Successfully updated!')));
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'How are you feeling now ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      controller: widget._textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      minLines: 3,
                      validator: textValidator,
                      decoration: InputDecoration(
                          fillColor: kActiveCardColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.transparent),
                          )),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        size: 35,
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: onPressed,
                    ),
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