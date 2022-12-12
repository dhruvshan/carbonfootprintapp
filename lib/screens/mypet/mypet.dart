import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/footprint/calculate_footprint.dart';
import 'package:flutter_application_1/screens/home/homepage.dart';
import 'package:flutter_application_1/screens/widget/navigation_drawer_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/myuser.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/settings/settings.dart';

var animal = '';
var myList;

class MyPetPage extends StatefulWidget {
  const MyPetPage({Key? key}) : super(key: key);

  @override
  State<MyPetPage> createState() => _MyPetPageState();
}

class _MyPetPageState extends State<MyPetPage> {
  final petName = "";
  double minHeight = 0.68;
  double maxHeight = 0.18;
  List<double> heightArray = [0.68, 0.68, 0.68, 0.68];
  String? _currentName;
  String? _currentEmail;
  int? _currentGoal;
  String? _currentPetName;
  String? _currentPetType;
  Object? _currentWaterHeight;
  Object? _currentScoreProgress;
  Object? _currentRecs;
  String? _currentCalcTime;
  int? _currentKillCount;
  double? _finalScore;
  Object? _currentPickedOptions;

  _buildCard({
    required Config config,
    Color? backgroundColor = Colors.transparent,
    DecorationImage? backgroundImage,
    double height = 152.0,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.only(
            right: marginHorizontal, left: marginHorizontal, bottom: 20.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: WaveWidget(
          config: config,
          backgroundColor: backgroundColor,
          backgroundImage: backgroundImage,
          size: Size(double.infinity, double.infinity),
          waveAmplitude: 0,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  double marginHorizontal = 20.0;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            animal = userData!.petType;
            myList = userData.waterHeight;
            if (userData.petType == "") {
              return SafeArea(
                  child: Scaffold(
                      backgroundColor: primaryColour,
                      drawer: NavigationDrawerWidget(),
                      appBar: AppBar(
                        title: Text(userData.petName,
                            style: TextStyle(color: Colors.white)),
                        backgroundColor: primaryColour,
                        centerTitle: true,
                        elevation: 0.0,
                      ),
                      body: Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: SingleChildScrollView(
                            child: Column(children: [
                              Card(
                                color: secondaryColour,
                                margin: EdgeInsets.all(16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                elevation: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 150,
                                        child:
                                            Image.asset('assets/combined.png'),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('You have not selected a pet!',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: primaryColour,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          "Go to Settings to select your Pet."),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('Click on the button below'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    primaryColour),
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    TextStyle(
                                                        color: Colors.white))),
                                        child: Text(
                                          'Settings',
                                        ),
                                        onPressed: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SettingsPage()));
                                          // }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                      )));
            } else {
              return Scaffold(
                  backgroundColor: primaryColour,
                  drawer: NavigationDrawerWidget(),
                  appBar: AppBar(
                    title: Text(userData.petName,
                        style: TextStyle(color: Colors.white)),
                    centerTitle: true,
                    backgroundColor: primaryColour,
                  ),
                  body: Center(
                      child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                                            'Your Pet',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 7, 35, 10)),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  'This is your Pet. Everytime you calculate a Carbon Footprint, your pets environment will float if you beat your Daily Goal and vice versa. ',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 7, 35, 10))),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  'Once the water level rises above the pet, you will have unfortunately killed it! So the objective is simple, reducing your Carbon Footprint = saving your pet!')
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.info)),
                            if (myList[1] < 0.28) ...[
                              AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(238, 248, 240, 227),
                                title: Text(
                                  'Your Pet is Dead',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 7, 35, 10)),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        'Yeap, you have killed it. I hope you are proud of yourself. Your continued increase in footprint has made the water level rise far too much for your pet to handle!',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 7, 35, 10))),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        'You really need to improve your footprint. Do you want to have a new pet?'),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    primaryColour),
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    TextStyle(
                                                        color: Colors.white))),
                                        onPressed: () async {
                                          setState(() {
                                            myList = [0.78, 0.78, 0.78, 0.78];
                                            _currentWaterHeight = myList;
                                          });
                                          await DatabaseService(uid: user?.uid)
                                              .updateUserData(
                                            _currentName ?? userData.name,
                                            _currentEmail ?? userData.email,
                                            _currentGoal ?? userData.goal,
                                            _currentPetName ?? userData.petName,
                                            _finalScore ?? userData.score,
                                            _currentPetType ?? userData.petType,
                                            _currentWaterHeight ??
                                                userData.waterHeight,
                                            _currentScoreProgress ??
                                                userData.scoreProgress,
                                            _currentRecs ?? userData.recoList,
                                            _currentCalcTime ??
                                                userData.lastCalcTime,
                                            _currentKillCount ??
                                                userData.killCount,
                                            _currentPickedOptions ??
                                                userData.pickedOptions,
                                          );
                                        },
                                        child: Text('Get New Pet'))
                                  ],
                                ),
                              ),
                            ],
                            _buildCard(
                              height: 500,
                              backgroundColor:
                                  Color.fromARGB(255, 255, 255, 255),
                              backgroundImage: DecorationImage(
                                  image:
                                      AssetImage('assets/' + animal + '.png'),
                                  scale: 0.8),
                              config: CustomConfig(
                                colors: [
                                  Color.fromARGB(255, 64, 87, 236),
                                  Color.fromARGB(255, 98, 202, 240),
                                  Color.fromARGB(255, 19, 53, 108),
                                  Color.fromARGB(255, 23, 110, 168)
                                ],
                                durations: [18000, 8000, 5000, 12000],
                                heightPercentages: List<double>.from(myList),
                              ),
                            ),
                          ]),
                    ),
                  )));
            }
          } else {
            return Text('pets');
          }
        });
  }
}
