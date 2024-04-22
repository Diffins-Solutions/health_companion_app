import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/utils/enums.dart';
import 'package:health_companion_app/widgets/profile_detail_box.dart';
import 'package:health_companion_app/widgets/profile_page_button.dart';
import 'package:health_companion_app/widgets/profile_picture.dart';

import '../../contollers/user_controller.dart';
import '../../models/db_models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final _nameFormKey = GlobalKey<FormState>();

  String name = 'Default user';
  Gender gender = Gender.female;
  int userId = 0 ;
  int? age;
  int? height;
  int? weight;
  int steps = 0;
  bool editMode = false;
  int minHeight = 80;
  int maxHeight = 180;
  int minWeight = 30;
  int maxWeight = 150;
  int maxAge = 120;
  int minAge = 8;
  Map<String,bool> errorMap = Map<String,bool>();

  void logout() {
    this.errorMap['update'] = false;
    print('logout clicked!');
  }

  void editProfile() {
    setState(() {
      this.errorMap['update'] = false;
      editMode = true;
    });
  }

  String? nameValidator(value){
    if (value == null || value.length < 5) {
      return 'Please enter a name with at least 5 characters';
    }
    return null;
  }

  void saveProfile() async{
    if (_nameFormKey.currentState!.validate()) {
      _nameFormKey.currentState!.save();
      if(age != null && height != null && weight != null){
        this.errorMap['age'] = false;
        this.errorMap['height'] = false;
        this.errorMap['weight'] = false;
        User updatedUser = User(
          id: userId,
          gender: gender == Gender.male ? 'Gender.male' : 'Gender.female',
          age: age!,
          weight: weight!,
          height: height!,
          name: name,
          steps: steps);
        bool isUpdated = await UserController.updateUser(updatedUser);
        if(isUpdated != null){
          if(!isUpdated){
            this.errorMap['update'] = true;
          }
          setState(() {
            editMode = false;
          });
        }

      }else{
        this.errorMap['age'] = age == null;
        this.errorMap['height'] = height == null;
        this.errorMap['weight'] = weight == null;
        setState(() {
        });
      }
      // User user = User(
      //   age: age!,
      //   gender: gender = Gender.male ? 'male', ,
      //
      // )
    }
  }

  void revertProfile() async {
    this.errorMap['age'] = false;
    this.errorMap['height'] = false;
    this.errorMap['weight'] = false;
    User user = await getUser();
    if (user != null) {
      setState(() {
        editMode = false;
      });
    }
  }

  void ageIncrease() {
    if(age != null){
      if(age! < maxAge){
        setState(() {
          age = age! + 1;
        });
      }
    }else{
      setState(() {
        age = minAge;
      });
    }
  }

  void ageDecrease() {
    if(age != null){
      if(age! > minAge){
        setState(() {
          age = age! - 1;
        });
      }
    }else{
      setState(() {
        age = minAge;
      });
    }
  }

  void heightIncrease() {
    if(height != null){
      if(height! < maxHeight){
        setState(() {
          height = height! + 1;
        });
      }
    }else{
      setState(() {
        height = minHeight;
      });
    }
  }

  void heightDecrease() {
    if(height != null){
      if(height! > minHeight){
        setState(() {
          height = height! - 1;
        });
      }
    }else{
      setState(() {
        height = minHeight;
      });
    }
  }

  void weightIncrease() {
    if(weight != null){
      if(weight! < maxWeight){
        setState(() {
          weight = weight! + 1;
        });
      }
    }else{
      setState(() {
        weight = minWeight;
      });
    }
  }

  void weightDecrease() {
    if(weight != null){
      if(weight! > minWeight){
        setState(() {
          weight = weight! - 1;
        });
      }
    }else{
      setState(() {
        height = minWeight;
      });
    }
  }

  Future<User> getUser() async {
    User user = await UserController.getUser();
    if (user != null) {
      print('User id: ${user.gender}');
      print('User: ${user}');
      setState(() {
        name = user.name;
        gender = user.gender == 'Gender.female' ? Gender.female : Gender.male;
        userId = user.id!;
        if (user.age != null) {
          age = user.age!;
        }
        if (user.height != null) {
          height = user.height!;
        }
        if (user.weight != null) {
          weight = user.weight!;
        }
        if (user.steps != null) {
          steps = user.steps!;
        }
      });
    }
    return user;
  }

  @override
  void initState() {
    super.initState();
    this.errorMap['age'] = false;
    this.errorMap['height'] = false;
    this.errorMap['weight'] = false;
    this.errorMap['update'] = false;
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Text('My Profile', style: TextStyle(fontWeight: FontWeight.w600),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10,top: 10),
              child: Center(child: ProfilePicture(address: gender == Gender.male ? 'images/male_dp.png' : 'images/female_dp.png')),
            ),
            SizedBox(height: 5,),
            editMode ?
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Form(
                key: _nameFormKey,
                child: TextFormField(
                  initialValue: '$name',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your name',
                  ),
                  validator: nameValidator,
                  onSaved: (value){
                    name = value!;
                  },
                ),
              ),
            ):
            Center(child: Text('$name', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),)),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
              child: ProfilePageButton(
                onPressed: logout,
                icon: Icons.logout,
                label: 'Logout',
                backgroundColor: Colors.redAccent,),

            ),
            !editMode ? Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            child: ProfilePageButton(
            onPressed: editProfile,
            icon: Icons.edit,
            label: 'Edit Profile',
            backgroundColor: kBackgroundColor,),
            ) : Row(
              children: [
                Expanded(
                  child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                  child: ProfilePageButton(
                  onPressed: revertProfile,
                  icon: Icons.arrow_back_outlined,
                  label: 'Discard Changes',
                  backgroundColor: kBackgroundColor,),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                    child: ProfilePageButton(
                      onPressed: saveProfile,
                      icon: Icons.save,
                      label: 'Save Changes',
                      backgroundColor: Colors.green,),
                  ),
                ),
              ],
            ),

            errorMap['update']! ?
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text('Error: User can not update!',
                style: TextStyle(color: Color(0xF0EFA4A4)),),
            ) :
            SizedBox(),

            errorMap['age']! ?
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text('Age required!',
                style: TextStyle(color: Color(0xF0EFA4A4)),),
            ) :
            SizedBox(),

            errorMap['height']! ?
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text('Height required!',
                style: TextStyle(color: Color(0xF0EFA4A4)),),
            ) :
            SizedBox(),

            errorMap['weight']! ?
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text('Weight required!',
                style: TextStyle(color: Color(0xF0EFA4A4)),),
            ) :
            SizedBox(),

            SizedBox(height: 10,),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProfileDetailBox(
                              title: 'Age',
                              value: age,
                              editMode: editMode,
                              onIncrease: ageIncrease,
                              onDecrease: ageDecrease,
                              minLimit: minAge,
                              maxLimit: maxAge,
                          ),
                        )),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProfileDetailBox(
                              title: 'Height',
                              value: height,
                              editMode: editMode,
                              onIncrease: heightIncrease,
                              onDecrease: heightDecrease,
                              minLimit: minHeight,
                              maxLimit: maxHeight,
                          ),
                        )),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProfileDetailBox(
                              title: 'Weight',
                              value: weight,
                              editMode: editMode,
                              onIncrease: weightIncrease,
                              onDecrease: weightDecrease,
                              minLimit: minWeight,
                              maxLimit: maxWeight,
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
