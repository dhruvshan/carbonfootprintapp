import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/myuser.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/screens/home/homepage.dart';

const List<String> list = <String>['Polar Bear', 'Seal', 'Penguins'];

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  String? _currentName;
  String? _currentEmail;
  num? _currentGoal;
  String? _currentPetName;
  num? _currentScore;
  String? _currentPetType;
  Object? _currentwaterHeight;
  Object? _currentScoreProgress;
  Object? _currentRecs;
  String? _currentCalcTime;
  int? _currentKillCount;
  Object? _currentPickedOptions;
  int? valueLength = 4;

  double _labelSize = 12.5;

  String _dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Scaffold(
              backgroundColor: Color.fromARGB(255, 35, 59, 37),
              appBar: AppBar(
                title: Text('My Profile'),
                centerTitle: true,
                backgroundColor: Color.fromARGB(255, 35, 59, 37),
              ),
              body: SingleChildScrollView(
                child: Card(
                    color: Color.fromARGB(238, 248, 240, 227),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    elevation: 10,
                    margin: EdgeInsets.all(16.0),
                    child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Expanded(
                                          child: AlertDialog(
                                            backgroundColor: Color.fromARGB(
                                                238, 248, 240, 227),
                                            title: Text(
                                              'Your Profile',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 7, 35, 10)),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    'This is your Profile Page. When you login for the first time, you will need to fill in your details. ',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 7, 35, 10))),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    'Please remember to fill in your Name, Pet Name and select your Pet Type too. Otherwise, you will not be able to enjoy this application!')
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.info)),
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Text(
                                    'Name:',
                                    style: TextStyle(
                                        fontSize: _labelSize,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColour),
                                  ),
                                ],
                              ),
                              TextFormField(
                                initialValue: userData!.name,
                                decoration: textInputDecoration,
                                inputFormatters: [
                                  // only accept letters from a to z
                                  FilteringTextInputFormatter(
                                      RegExp(r'[a-zA-Z]'),
                                      allow: true)
                                ],
                                validator: (val) =>
                                    val!.isEmpty ? 'Please add' : null,
                                onChanged: (val) =>
                                    setState(() => _currentName = val),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                children: [
                                  Text(
                                    'Email Address:',
                                    style: TextStyle(
                                        fontSize: _labelSize,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColour),
                                  ),
                                ],
                              ),
                              TextFormField(
                                initialValue: userData.email,
                                decoration: textInputDecoration,
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) => val!.isEmpty &&
                                        !EmailValidator.validate(val)
                                    ? 'Update your email'
                                    : null,
                                onChanged: (val) =>
                                    setState(() => _currentEmail = val),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                children: [
                                  Text(
                                    "Carbon Footprint Goal:",
                                    style: TextStyle(
                                        fontSize: _labelSize,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColour),
                                  ),
                                ],
                              ),
                              TextFormField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  initialValue: userData.goal.toString(),
                                  decoration: textInputDecoration,
                                  inputFormatters: [
                                    FilteringTextInputFormatter(
                                        RegExp(r'(^\d*\.?\d*)'),
                                        allow: true),
                                    LengthLimitingTextInputFormatter(
                                        valueLength),
                                  ],
                                  validator: (val) =>
                                      val!.isEmpty ? 'Update your email' : null,
                                  onChanged: (val) {
                                    try {
                                      setState(() {
                                        var doubleValue =
                                            double.tryParse("0" + val);
                                        if (doubleValue ==
                                            doubleValue!.roundToDouble()) {
                                          valueLength = 4;
                                          print('4');
                                        } else {
                                          valueLength = 5;
                                          print('5');
                                        }
                                        _currentGoal = doubleValue;
                                      });
                                    } on FormatException catch (e) {
                                      print(e);
                                    } catch (e) {
                                      throw UnknownException('EEE');
                                    }
                                  }),
                              SizedBox(height: 20.0),
                              Row(
                                children: [
                                  Text(
                                    "Pet's Name:",
                                    style: TextStyle(
                                        fontSize: _labelSize,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColour),
                                  ),
                                ],
                              ),
                              TextFormField(
                                initialValue: userData.petName,
                                decoration: textInputDecoration,
                                inputFormatters: [
                                  FilteringTextInputFormatter(
                                      RegExp(r'[a-zA-Z]'),
                                      allow: true)
                                ],
                                validator: (val) => val!.isEmpty
                                    ? "Update your Pet's name"
                                    : null,
                                onChanged: (val) =>
                                    setState(() => _currentPetName = val),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                children: [
                                  Text(
                                    "Pet Type:",
                                    style: TextStyle(
                                        fontSize: _labelSize,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColour),
                                  ),
                                ],
                              ),
                              DropdownButton<String>(
                                  isExpanded: true,
                                  value: _currentPetType,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _currentPetType = newValue!;
                                    });
                                  }),
                              SizedBox(height: 20.0),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 35, 59, 37)),
                                    textStyle: MaterialStateProperty.all(
                                        TextStyle(color: Colors.white))),
                                child: Text(
                                  'Update',
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await DatabaseService(uid: user?.uid)
                                        .updateUserData(
                                      _currentName ?? userData.name,
                                      _currentEmail ?? userData.email,
                                      _currentGoal ?? userData.goal,
                                      _currentPetName ?? userData.petName,
                                      _currentScore ?? userData.score,
                                      _currentPetType ?? userData.petType,
                                      _currentwaterHeight ??
                                          userData.waterHeight,
                                      _currentScoreProgress ??
                                          userData.scoreProgress,
                                      _currentRecs ?? userData.recoList,
                                      _currentCalcTime ?? userData.lastCalcTime,
                                      _currentKillCount ?? userData.killCount,
                                      _currentPickedOptions ??
                                          userData.pickedOptions,
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                              )
                            ],
                          ),
                        ))),
              ),
            );
          } else {
            return Text('');
          }
        });
  }
}

class InvalidFormatException {
  String message;
  InvalidFormatException(this.message);
}

class UnknownException {
  String message;
  UnknownException(this.message);
}
