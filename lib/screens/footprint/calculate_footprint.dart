import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/googlemaps/embediframe.dart';
// import 'package:flutter_application_1/screens/googlemaps/googlemaps.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter_application_1/screens/home/homepage.dart';
// import 'package:flutter_application_1/screens/home/homepage.dart';
// import 'package:flutter_application_1/screens/widget/navigation_drawer_widget.dart';
import 'package:flutter_application_1/shared/constants.dart';
import 'package:flutter_application_1/shared/loading.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/myuser.dart';
import 'package:flutter_application_1/services/database.dart';
// import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';

var variable1;
var metGoal = "";
final recommendationList = ['', '', ''];
final benefit = ['', '', ''];
var optionChoices = ["Car", "Train", "Aluminium", "Papers", "Clothing"];

class CarbonFootprint extends StatefulWidget {
  const CarbonFootprint({Key? key}) : super(key: key);

  @override
  State<CarbonFootprint> createState() => _CarbonFootprintState();
}

class _CarbonFootprintState extends State<CarbonFootprint> {
  bool isChecked = false;
  bool didRecycle = false;
  final _formKey = GlobalKey<FormState>();
  double? _currentFuel = 0;
  double? _currentEnergy;
  double vegCo2 = 0;
  double? fuelCo2;
  double energyCo2 = 0;
  double recycleCo2 = 0;
  double? _finalScore = 0;
  double _currentFoodValue = 0;
  double? _currentScore = 0;
  var myscoreArray;
  var myrecsArray;
  var myoptionsArray;
  var _foodName = "";
  bool isKilled = false;
  var _currentTransportEndpoint = "0";
  final pageFont = 16.0;
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
  Object? _currentPickedOptions;
  var mylist;
  var selectedFont = 12.0;
  var _transportName;
  var statusText = "Simple";
  bool isAdvanced = false;
  bool _isLoading = false;

  int? valueLength = 4;

  DateFormat dateFormat = DateFormat("EEEE");
  DateFormat dayFormat = DateFormat('yMMMMd');

  var pickedOptions = [];
  Map pickedOptionsMap = {};

  var _currentFoodEndpoint = "";

  var prevTime = "2022-11-07 06:20:00.000000";

  String _status = '\$';

  final _transport = ["Bicycle", "Car", "Train", "Walking"];

  final _transportImages = [
    "assets/transport/bicycle.png",
    "assets/transport/car.png",
    "assets/transport/train.png",
    "assets/transport/walking.png"
  ];

  final _apiTransport = [
    "0",
    "passenger_vehicle-vehicle_type_business_travel_car-fuel_source_na-engine_size_na-vehicle_age_na-vehicle_weight_na",
    "passenger_train-route_type_na-fuel_source_electricity",
    "0",
  ];

  final _foodOptions = ["Vegetables", "Beef", "Pork", "Poultry", "Seafood"];

  final _apiFood = [
    "f86abeab-6946-4678-ae2d-2bc885f7b338", //vege
    "fc85d68d-2450-4338-9ee7-6dca7b5315df", //beef
    "f8313085-b0a1-4eb8-bc4b-45b68bcd0c43", //pork
    "3595b315-6fd0-4006-b04f-0563f6fe647f", //poultry
    "1990f9a1-3e7c-48a8-9228-6ac6bfaf48dd", //seafood
  ];

  final _foodImages = [
    "assets/food/Vegetables.png",
    "assets/food/Beef.png",
    "assets/food/Bacon.png",
    "assets/food/Poultry.png",
    "assets/food/Seafood.png",
  ];

  final _recycleOptions = ['Aluminium', 'Papers', 'Clothing'];
  List<double?> _recycleAmounts = [0.0, 0.0, 0.0];
  var recycleNames = ['Aluminium', 'Papers', 'Clothing'];

  final _apiRecylce = [
    "1edaa482-ab7f-4c42-bc5b-7a98837c99d8", //aluminium
    "d48f9217-c8fd-4f8a-952a-e758987cdf72", //paper
    "cb21c1f0-ce04-40ae-95a8-e35adc08a2fa", //clothing
  ];
  final _recycleMaterial = [
    "assets/materials/can.png",
    "assets/materials/documents.png",
    "assets/materials/clothes.png",
  ];

  List<double> _foodAmounts = [0.0, 0.0, 0.0, 0.0, 0.0];

  var foodListCo2 = [10.0, 10.0, 10.0, 10.0, 10.0, 10.0];

  var imagesPath = [
    "assets/foodOption/chickenRice.png",
    "assets/foodOption/crab.png",
    "assets/foodOption/nasiLemak.png",
    "assets/foodOption/porkSoup.png",
    "assets/foodOption/coffeeToast.png",
    "assets/foodOption/paratha.png",
  ];

  var imagesChecked = [
    "assets/foodOption/chickenRiceYes.png",
    "assets/foodOption/crabYes.png",
    "assets/foodOption/nasiLemakYes.png",
    "assets/foodOption/porkSoupYes.png",
    "assets/foodOption/coffeeToastYes.png",
    "assets/foodOption/parathaYes.png",
  ];

  var simpleFoodnames = [
    "Chicken Rice",
    "Chilli Crab",
    "Nasi Lemak",
    "Bat Kuh Teh",
    "Kaya Toast",
    "Murtabak"
  ];

  var selectedState = [false, false, false, false, false, false];

  @override
  void initState() {
    selectedState = [false, false, false, false, false, false];
    variable1 = "";
    _transportName = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;

            mylist = userData?.waterHeight;
            mylist = List<double>.from(mylist);

            myscoreArray = userData?.scoreProgress;
            myscoreArray = List<double>.from(myscoreArray);

            myoptionsArray = userData?.pickedOptions;
            myoptionsArray = List.from(myoptionsArray);

            myrecsArray = userData?.recoList;
            myrecsArray = List<String>.from(myrecsArray);

            return Scaffold(
              backgroundColor: primaryColour,
              appBar: AppBar(
                title: const Text(
                  'Calculate Footprint',
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
                backgroundColor: primaryColour,
              ),
              body: SingleChildScrollView(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      Card(
                        color: const Color.fromARGB(238, 248, 240, 227),
                        margin: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        elevation: 10,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
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
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            238, 248, 240, 227),
                                                    title: Text(
                                                      'Calculating a Footprint',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 7, 35, 10)),
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('Diet',
                                                                style: TextStyle(
                                                                    color:
                                                                        primaryColour,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18)),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                            'We know that you may have had a combination of these foods today. Pick one from the Simple options. If you want more detail, toggle to the Advanced Mode and slide accordingly.',
                                                            style: TextStyle(
                                                                color:
                                                                    primaryColour)),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                'Transportation',
                                                                style: TextStyle(
                                                                    color:
                                                                        primaryColour,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18)),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                            'Walking and cycling have zero footprint. If you have used multiple modes of transport select 1 in order of Car, Train, Bicycle, Walking respectively.',
                                                            style: TextStyle(
                                                                color:
                                                                    primaryColour)),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text('Recycling',
                                                                style: TextStyle(
                                                                    color:
                                                                        primaryColour,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18)),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                            'Only select if you have recycled. Items that can be recycled include Aluminium, Paper and Clothes. If you have recycled only one type of item, please remember to put 0 for the rest.',
                                                            style: TextStyle(
                                                                color:
                                                                    primaryColour)),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text('Energy Usage',
                                                                style: TextStyle(
                                                                    color:
                                                                        primaryColour,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18)),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                            'Enter your electricity meter reading for the last month/30 days. The system will automatically calculate a daily estimated value.',
                                                            style: TextStyle(
                                                                color:
                                                                    primaryColour)),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.info)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20.0, 8, 20.0, 0),
                                            child: Text(
                                              'Estimated diet spend today',
                                              style: TextStyle(
                                                  fontSize: pageFont,
                                                  color: primaryColour,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2.0),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 0, 0, 0),
                                        child: Row(
                                          children: [
                                            Text(statusText),
                                            Switch(
                                                value: isAdvanced,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isAdvanced = value;
                                                    if (value == true) {
                                                      statusText = "Advanced";
                                                    } else {
                                                      statusText = "Simple";
                                                    }
                                                  });
                                                })
                                          ],
                                        ),
                                      ),
                                      if (isAdvanced == false) ...[
                                        Container(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 0, 20, 0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    for (var i = 0;
                                                        i < 3;
                                                        i++) ...[
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                              iconSize: 50.0,
                                                              onPressed: (() {
                                                                setState(() {
                                                                  selectedState[
                                                                          i] =
                                                                      !selectedState[
                                                                          i];
                                                                  icon:
                                                                  Image.asset(
                                                                      imagesChecked[
                                                                          i]);
                                                                });
                                                              }),
                                                              icon: Image.asset(
                                                                  selectedState[i]
                                                                      ? imagesChecked[
                                                                          i]
                                                                      : imagesPath[
                                                                          i])),
                                                          Text(
                                                            simpleFoodnames[i],
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    for (var i = 3;
                                                        i < 6;
                                                        i++) ...[
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                              iconSize: 50.0,
                                                              onPressed: (() {
                                                                setState(() {
                                                                  selectedState[
                                                                          i] =
                                                                      !selectedState[
                                                                          i];
                                                                });
                                                              }),
                                                              icon: Image.asset(
                                                                  selectedState[i]
                                                                      ? imagesChecked[
                                                                          i]
                                                                      : imagesPath[
                                                                          i])),
                                                          Text(
                                                            simpleFoodnames[i],
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          )
                                                        ],
                                                      )
                                                    ]
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ],
                                      if (isAdvanced == true) ...[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20.0, 0, 20.0, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              for (var i = 0; i < 5; i++) ...[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        InkWell(
                                                          child: Image.asset(
                                                            _foodImages[i],
                                                            height: 50,
                                                            width: 50,
                                                          ),
                                                          onTap: () {
                                                            setState(() {});
                                                          },
                                                          splashColor:
                                                              Colors.white,
                                                        ),
                                                        Container(
                                                          width: 80,
                                                          child: Center(
                                                            child: Text(
                                                              _foodOptions[i],
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      width: 30,
                                                      child: Text("\$" +
                                                          _foodAmounts[i]
                                                              .toStringAsFixed(
                                                                  0)),
                                                    ),
                                                    Container(
                                                      width: 150,
                                                      child: Slider(
                                                        min: 0,
                                                        max: 50,
                                                        value: _foodAmounts[i],
                                                        activeColor:
                                                            primaryColour,
                                                        divisions: 50,
                                                        label: _foodAmounts[i]
                                                            .round()
                                                            .toString(),
                                                        onChanged:
                                                            (double value) {
                                                          setState(() {
                                                            _foodAmounts[i] =
                                                                value;
                                                            _status =
                                                                '${_foodAmounts[i].round()}';
                                                            print(_foodAmounts);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                )
                                              ]
                                            ],
                                          ),
                                        ),
                                      ],

                                      if (_currentFoodEndpoint != "") ...[
                                        const SizedBox(height: 20.0),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Today\'s spend on $_foodName (\$ $_status)',
                                            style: TextStyle(
                                                fontSize: pageFont - 2.0,
                                                color: primaryColour),
                                          ),
                                        ),
                                        Slider(
                                          min: 0,
                                          max: 500,
                                          value: _currentFoodValue,
                                          activeColor: primaryColour,
                                          divisions: 500,
                                          label: _currentFoodValue
                                              .round()
                                              .toString(),
                                          onChanged: (double value) {
                                            setState(() {
                                              _currentFoodValue = value;
                                              _status =
                                                  '${_currentFoodValue.round()}';
                                            });
                                          },
                                        ),
                                      ],
                                      SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Did you travel today?',
                                            style: TextStyle(
                                                fontSize: pageFont,
                                                color: primaryColour,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Checkbox(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            checkColor: Colors.white,
                                            value: isChecked,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked = value!;
                                              });
                                            },
                                          ),
                                        ],
                                      ), //Text
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      if (isChecked == true) ...[
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                for (var i = 0; i < 4; i++)
                                                  Column(
                                                    children: [
                                                      InkWell(
                                                        enableFeedback: true,
                                                        child: Image.asset(
                                                          _transportImages[i],
                                                          height: 50,
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            _currentTransportEndpoint =
                                                                _apiTransport[
                                                                    i];
                                                            variable1 =
                                                                _transport[i];
                                                            _transportName =
                                                                variable1;
                                                          });
                                                        },
                                                        splashColor:
                                                            Colors.orange,
                                                        highlightColor:
                                                            Colors.orange,
                                                      ),
                                                      Text(
                                                        _transport[i],
                                                        style: TextStyle(
                                                            fontSize: 12.0),
                                                      )
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                      if (_currentTransportEndpoint == "0" &&
                                          (isChecked == true)) ...[
                                        const SizedBox(height: 20.0),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      22, 8, 0, 0),
                                              child: Text(
                                                'You traveled via $variable1',
                                                style: TextStyle(
                                                    color: primaryColour,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                      if (_currentTransportEndpoint != "0" &&
                                          (isChecked == true)) ...[
                                        const SizedBox(height: 20.0),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      22, 8, 0, 0),
                                              child: Text(
                                                'How far did you travel today via $variable1? (km)',
                                                style: TextStyle(
                                                    fontSize: pageFont - 2.0,
                                                    color: primaryColour,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 310,
                                          child: TextFormField(
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              decoration: textInputDecoration,
                                              inputFormatters: [
                                                FilteringTextInputFormatter(
                                                    RegExp(r'(^\d*\.?\d*)'),
                                                    allow: true),
                                                LengthLimitingTextInputFormatter(
                                                    valueLength),
                                              ],
                                              validator: (val) => val!.isEmpty
                                                  ? 'Please add the distance travelled in km'
                                                  : null,
                                              onChanged: (val) {
                                                if (val != "") {
                                                  setState(() {
                                                    var doubleValue =
                                                        double.tryParse(val);
                                                    if (doubleValue ==
                                                        doubleValue!
                                                            .roundToDouble()) {
                                                      valueLength = 4;
                                                      print('4');
                                                    } else {
                                                      valueLength = 5;
                                                      print('5');
                                                    }
                                                    _currentFuel = doubleValue;
                                                  });
                                                }
                                              }),
                                        ),
                                      ],
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Did you recycle today?',
                                            style: TextStyle(
                                                fontSize: pageFont,
                                                color: primaryColour,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Checkbox(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            checkColor: Colors.white,
                                            value: didRecycle,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                didRecycle = value!;
                                              });
                                              if (didRecycle) {
                                                print('True');
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      if (didRecycle == true) ...[
                                        Column(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Expanded(
                                                        child: AlertDialog(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  238,
                                                                  248,
                                                                  240,
                                                                  227),
                                                          title: const Text(
                                                            'Recycling',
                                                            style: TextStyle(
                                                                color:
                                                                    primaryColour),
                                                          ),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const Text(
                                                                'Did you know you can earn money by recycling? In Singapore the rates for recyling are:',
                                                                style: TextStyle(
                                                                    color:
                                                                        primaryColour),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'Aluminium'),
                                                                  Text(
                                                                      '\$0.50 per kg')
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text('Paper'),
                                                                  Text(
                                                                      '\$0.10 per kg')
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      'Clothes'),
                                                                  Text(
                                                                      '\$0.10 per kg')
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      backgroundColor: MaterialStatePropertyAll<
                                                                              Color>(
                                                                          Color.fromARGB(
                                                                              255,
                                                                              7,
                                                                              35,
                                                                              10))),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                WebViewExample()));
                                                                  },
                                                                  child: Text(
                                                                      'Go to Map')),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: Icon(Icons.info)),
                                            for (var r = 0; r < 3; r++)
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      InkWell(
                                                        child: Image.asset(
                                                          _recycleMaterial[r],
                                                          height: 50,
                                                        ),
                                                        onTap: () {},
                                                        splashColor:
                                                            Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width: 100,
                                                      ),
                                                      Text(_recycleOptions[r]),
                                                      const SizedBox(
                                                        height: 20,
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    child: TextFormField(
                                                      keyboardType: TextInputType
                                                          .numberWithOptions(
                                                              decimal: true),
                                                      decoration:
                                                          textInputDecoration,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter(
                                                            RegExp(
                                                                r'(^\d*\.?\d*)'),
                                                            allow: true),
                                                        LengthLimitingTextInputFormatter(
                                                            3),
                                                      ],
                                                      validator: (val) =>
                                                          val!.isEmpty
                                                              ? 'Please add'
                                                              : null,
                                                      onChanged: (value) {
                                                        if (value != "") {
                                                          setState(() {
                                                            _recycleAmounts[r] =
                                                                double.tryParse(
                                                                    value);
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const Text('\$'),
                                                ],
                                              )
                                          ],
                                        )
                                      ],
                                      const SizedBox(height: 20.0),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20.0, 8, 0, 0),
                                            child: Text(
                                              'Energy consumed in a month (kWh)?',
                                              style: TextStyle(
                                                  fontSize: pageFont,
                                                  color: primaryColour,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 310,
                                        child: TextFormField(
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          decoration: textInputDecoration,
                                          inputFormatters: [
                                            FilteringTextInputFormatter(
                                                RegExp(r'(^\d*\.?\d*)'),
                                                allow: true),
                                            LengthLimitingTextInputFormatter(
                                                valueLength),
                                          ],
                                          validator: (val) => val!.isEmpty
                                              ? 'Please add'
                                              : null,
                                          onChanged: (val) {
                                            if (val != "") {
                                              setState(() {
                                                var doubleValue =
                                                    double.tryParse(val);
                                                if (doubleValue ==
                                                    doubleValue!
                                                        .roundToDouble()) {
                                                  valueLength = 4;
                                                  print('4');
                                                } else {
                                                  valueLength = 5;
                                                  print('5');
                                                }
                                                _currentEnergy =
                                                    doubleValue / 30;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30.0,
                                      ),

                                      ElevatedButton.icon(
                                        icon: _isLoading
                                            ? Container(
                                                width: 24,
                                                height: 24,
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child:
                                                    const CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 3,
                                                ),
                                              )
                                            : Icon(Icons.calculate),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color.fromARGB(
                                                        255, 35, 59, 37)),
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    const TextStyle(
                                                        color: Colors.white))),
                                        label: const Text(
                                          'Calculate',
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          pickedOptionsMap['Date'] =
                                              dayFormat.format(DateTime.now());
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final uri = Uri.parse(
                                                'https://beta3.api.climatiq.io/estimate');
                                            final token =
                                                '##Enter your Climatiq API Key##';
                                            final headers = {
                                              HttpHeaders.contentTypeHeader:
                                                  'application/json',
                                              HttpHeaders.authorizationHeader:
                                                  'Bearer $token',
                                            };
                                            var allFoodCo2 = [
                                              0.0,
                                              0.0,
                                              0.0,
                                              0.0,
                                              0.0
                                            ];
                                            var maxFoodCo2 = [0, 0.0];
                                            for (var i = 0; i < 5; i++) {
                                              Map<String, dynamic> body = {
                                                "emission_factor": {
                                                  "uuid": _apiFood[i]
                                                },
                                                "parameters": {
                                                  "money": _foodAmounts[i],
                                                  "money_unit": "sgd"
                                                }
                                              };
                                              String jsonBody =
                                                  json.encode(body);
                                              final encoding =
                                                  Encoding.getByName('utf-8');

                                              Response response = await post(
                                                uri,
                                                headers: headers,
                                                body: jsonBody,
                                                encoding: encoding,
                                              );
                                              // int statusCode =
                                              //     response.statusCode;
                                              Map<String, dynamic> allFoodData =
                                                  new Map<String, dynamic>.from(
                                                      json.decode(
                                                          response.body));
                                              print('Current co2:' +
                                                  allFoodData['co2e']
                                                      .toString());
                                              if (allFoodData['co2e'] >
                                                  maxFoodCo2[1]) {
                                                maxFoodCo2[0] = i;
                                                maxFoodCo2[1] =
                                                    allFoodData['co2e'];
                                              }
                                              setState(() {
                                                allFoodCo2[i] =
                                                    allFoodData['co2e'];
                                                vegCo2 = allFoodData['co2e'] +
                                                    vegCo2;
                                              });
                                            }
                                            var foodRec;
                                            if (maxFoodCo2[0] == 0) {
                                              setState(() {
                                                foodRec = "";
                                              });
                                            } else {
                                              var index = maxFoodCo2[0];
                                              var badName =
                                                  _foodOptions[index.toInt()];
                                              var coSave = (maxFoodCo2[1] -
                                                      allFoodCo2[0])
                                                  .toStringAsFixed(2);
                                              foodRec =
                                                  'Eat more Vegetables than $badName. You will save $coSave kg${"CO\u2082e"}';
                                            }
                                            if (_currentTransportEndpoint ==
                                                "0") {
                                              fuelCo2 = 0;
                                              pickedOptions.add(_transportName);
                                            } else {
                                              if (_currentFuel != 0) {
                                                Map<String, dynamic> body = {
                                                  "emission_factor": {
                                                    "activity_id":
                                                        _currentTransportEndpoint
                                                  },
                                                  "parameters": {
                                                    "distance": _currentFuel,
                                                    "distance_unit": "km"
                                                  }
                                                };
                                                String jsonBody =
                                                    json.encode(body);
                                                final encoding =
                                                    Encoding.getByName('utf-8');

                                                Response response = await post(
                                                  uri,
                                                  headers: headers,
                                                  body: jsonBody,
                                                  encoding: encoding,
                                                );
                                                Map<String, dynamic> fuelData =
                                                    new Map<String,
                                                            dynamic>.from(
                                                        json.decode(
                                                            response.body));
                                                fuelCo2 = fuelData['co2e'] ?? 0;
                                                print(fuelCo2);
                                              }
                                              pickedOptionsMap[_transportName] =
                                                  _currentFuel;
                                            }
                                            var transRec = '';
                                            print(pickedOptions);

                                            if (isChecked == true) {
                                              if (_transportName == "Car") {
                                                setState(() {
                                                  transRec =
                                                      "Use Public Transport instead of Cars! You can reduce your footprint by more than 10%";
                                                });
                                              }
                                              if (_currentFuel == 0) {
                                                setState(() {
                                                  transRec = "";
                                                });
                                              }
                                              if (_currentFuel! < 10 &&
                                                  (_transportName !=
                                                          "Walking" &&
                                                      _transportName !=
                                                          "Bicycle")) {
                                                setState(() {
                                                  transRec =
                                                      "Walk or use a Bicycle instead! They have almost 0 carbon footprint!";
                                                });
                                              }
                                            }
                                            setState(() {
                                              myrecsArray[0] = foodRec;
                                              myrecsArray[1] = transRec;
                                              _currentRecs = myrecsArray;
                                            });

                                            print(_currentRecs);

                                            if (didRecycle == true) {
                                              for (var r = 0; r < 3; r++) {
                                                Map<String, dynamic> body = {
                                                  "emission_factor": {
                                                    "uuid": _apiRecylce[r]
                                                  },
                                                  "parameters": {
                                                    "money": _recycleAmounts[r],
                                                    "money_unit": "sgd"
                                                  }
                                                };
                                                if (_recycleAmounts[r] != 0) {
                                                  pickedOptionsMap[
                                                          recycleNames[r]] =
                                                      _recycleAmounts[r];
                                                }
                                                String jsonBody =
                                                    json.encode(body);
                                                final encoding =
                                                    Encoding.getByName('utf-8');

                                                Response response = await post(
                                                  uri,
                                                  headers: headers,
                                                  body: jsonBody,
                                                  encoding: encoding,
                                                );
                                                Map<String, dynamic>
                                                    recycleData = new Map<
                                                            String,
                                                            dynamic>.from(
                                                        json.decode(
                                                            response.body));
                                                print('Current co2:' +
                                                    recycleData['co2e']
                                                        .toString());
                                                setState(() {
                                                  recycleCo2 =
                                                      recycleData['co2e'] +
                                                          recycleCo2;
                                                });
                                              }
                                            }
                                            print(pickedOptionsMap);
                                            setState(() {
                                              var last =
                                                  myoptionsArray.length - 1;
                                              if (!myoptionsArray.isEmpty) {
                                                if (pickedOptionsMap['Date'] ==
                                                    myoptionsArray[last]
                                                        ['Date']) {
                                                  for (var i = 0; i < 5; i++) {
                                                    if (myoptionsArray[last]
                                                            .containsKey(
                                                                optionChoices[
                                                                    i]) &&
                                                        pickedOptionsMap
                                                            .containsKey(
                                                                optionChoices[
                                                                    i])) {
                                                      myoptionsArray[last][
                                                              optionChoices[
                                                                  i]] =
                                                          0 +
                                                              myoptionsArray[
                                                                      last][
                                                                  optionChoices[
                                                                      i]] +
                                                              pickedOptionsMap[
                                                                  optionChoices[
                                                                      i]];
                                                    } else {
                                                      if (pickedOptionsMap[
                                                              optionChoices[
                                                                  i]] !=
                                                          null) {
                                                        myoptionsArray[last][
                                                                optionChoices[
                                                                    i]] =
                                                            // 0 +
                                                            pickedOptionsMap[
                                                                optionChoices[
                                                                    i]];
                                                      }
                                                    }
                                                  }
                                                } else {
                                                  myoptionsArray
                                                      .add(pickedOptionsMap);
                                                }
                                              } else {
                                                myoptionsArray
                                                    .add(pickedOptionsMap);
                                              }

                                              _currentPickedOptions =
                                                  myoptionsArray;
                                            });

                                            if (_currentEnergy != 0) {
                                              Map<String, dynamic> body = {
                                                "emission_factor": {
                                                  "activity_id":
                                                      "electricity-energy_source_grid_mix"
                                                },
                                                "parameters": {
                                                  "energy": _currentEnergy,
                                                  "energy_unit": "kWh"
                                                }
                                              };
                                              String jsonBody =
                                                  json.encode(body);
                                              final encoding =
                                                  Encoding.getByName('utf-8');

                                              Response response = await post(
                                                uri,
                                                headers: headers,
                                                body: jsonBody,
                                                encoding: encoding,
                                              );
                                              Map<String, dynamic> energyData =
                                                  new Map<String, dynamic>.from(
                                                      json.decode(
                                                          response.body));
                                              energyCo2 = energyData['co2e'];
                                            }
                                            var simpleFoodCo2 = 0.0;
                                            print(_finalScore);
                                            for (var i = 0; i < 6; i++) {
                                              if (selectedState[i] == true) {
                                                simpleFoodCo2 += foodListCo2[i];
                                              }
                                            }

                                            setState(() {
                                              _finalScore = simpleFoodCo2 +
                                                  fuelCo2! +
                                                  energyCo2 +
                                                  vegCo2 -
                                                  recycleCo2;
                                              _finalScore = double.parse(
                                                  _finalScore!
                                                      .toStringAsFixed(2));
                                              _currentScore = _finalScore;
                                            });
                                            _currentCalcTime = dateFormat
                                                .format(DateTime.now());

                                            if (_finalScore! > userData!.goal) {
                                              for (var i = 0;
                                                  i < mylist.length;
                                                  i++) {
                                                if (mylist[i] >= 0.28) {
                                                  mylist[i] = mylist[i] - 0.10;
                                                }
                                                if (mylist[i] < 0.28) {
                                                  setState(() {
                                                    isKilled = true;
                                                    _currentKillCount =
                                                        userData.killCount + 1;
                                                  });
                                                }
                                              }
                                              setState(() {
                                                _currentWaterHeight = mylist;
                                              });
                                            }
                                            if (_finalScore! < userData.goal) {
                                              for (var i = 0;
                                                  i < mylist.length;
                                                  i++) {
                                                if (mylist[i] < 0.78) {
                                                  mylist[i] = mylist[i] + 0.10;
                                                }
                                              }
                                              setState(() {
                                                _currentWaterHeight = mylist;
                                              });
                                            }

                                            if (_finalScore != 0) {
                                              if (_currentCalcTime ==
                                                  userData.lastCalcTime) {
                                                _finalScore = myscoreArray[
                                                        myscoreArray.length -
                                                            1] +
                                                    _finalScore;
                                                myscoreArray[
                                                    myscoreArray.length -
                                                        1] = _finalScore;
                                              } else {
                                                myscoreArray.add(_finalScore);
                                              }
                                              setState(() {
                                                _currentScoreProgress =
                                                    myscoreArray;
                                                _isLoading = false;
                                              });
                                            }
                                            await DatabaseService(
                                                    uid: user?.uid)
                                                .updateUserData(
                                              _currentName ?? userData.name,
                                              _currentEmail ?? userData.email,
                                              _currentGoal ?? userData.goal,
                                              _currentPetName ??
                                                  userData.petName,
                                              _finalScore ?? userData.score,
                                              _currentPetType ??
                                                  userData.petType,
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
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.5)),
                                                      elevation: 16,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: ListView(
                                                          shrinkWrap: true,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          children: <Widget>[
                                                            const SizedBox(
                                                              height: 15.0,
                                                            ),
                                                            if (_finalScore! <
                                                                userData
                                                                    .goal) ...[
                                                              Text(
                                                                'You did it! You made ${userData.petName} happy!',
                                                                style: TextStyle(
                                                                    color:
                                                                        primaryColour,
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                            if (_finalScore! <
                                                                0) ...[
                                                              Text(
                                                                  'You scored less than zero! That is insane. Means you actually absorbed more than you emitted. Nice work!')
                                                            ],
                                                            if (_finalScore! >
                                                                userData
                                                                    .goal) ...[
                                                              Text(
                                                                  'You failed your goal! ${userData.petName} is very sad!'),
                                                            ],
                                                            SizedBox(
                                                              height: 15.0,
                                                            ),
                                                            Text('Your current footprint is ' +
                                                                _currentScore
                                                                    .toString() +
                                                                "kg${"CO\u2082e"}"),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            ElevatedButton(
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(Color.fromARGB(
                                                                            255,
                                                                            35,
                                                                            59,
                                                                            37)),
                                                                    textStyle: MaterialStateProperty.all(TextStyle(
                                                                        color: Colors
                                                                            .white))),
                                                                child: Text(
                                                                  'Go Home',
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  if (userData
                                                                          .score >
                                                                      userData
                                                                          .goal) {
                                                                    setState(
                                                                        () {
                                                                      metGoal =
                                                                          "no";
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      metGoal =
                                                                          "yes";
                                                                    });
                                                                  }
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              HomePage()));
                                                                })
                                                          ],
                                                        ),
                                                      ));
                                                });
                                          }
                                        },
                                      ),
                                    ])),
                          ),
                        ),
                      ),
                    ])),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
