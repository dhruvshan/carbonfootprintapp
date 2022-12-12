import "dart:math";
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/chart/chart.dart';
import 'package:flutter_application_1/screens/chart/fullchart.dart';
import 'package:flutter_application_1/screens/footprint/calculate_footprint.dart';
import 'package:flutter_application_1/screens/googlemaps/googlemaps.dart';
import 'package:flutter_application_1/screens/mypet/mypet.dart';
import 'package:flutter_application_1/screens/ranking/rankings.dart';
import 'package:flutter_application_1/screens/settings/settings.dart';
import 'package:flutter_application_1/screens/widget/navigation_drawer_widget.dart';
import 'package:flutter_application_1/services/storage_service.dart';
import 'package:flutter_application_1/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/myuser.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/screens/googlemaps/embediframe.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:collection/collection.dart';
import 'package:getwidget/getwidget.dart';
// import 'package:fl_chart/fl_chart.dart';

const primaryColour = Color.fromARGB(255, 35, 59, 37);
const secondaryColour = Color.fromARGB(238, 248, 240, 227);
var username = '';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<String>> futureList;
  var _currentColor = Colors.green;
  var _topText = "";
  var mylist;

  var allData;
  var status;
  var indexes;

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('recommendations');

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    setState(() {
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      element = allData[_random.nextInt(allData.length)]['text'];
    });
  }

  final _random = new Random();
  var element;
  num percentageForBar = 0;
  var colorForBar;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<MyUser?>(context);
    final Storage storage = Storage();
    final user = Provider.of<MyUser?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            mylist = userData?.waterHeight;
            mylist = List<double>.from(mylist);

            if (userData!.score > userData.goal) {
              _currentColor = Colors.red;
              status = "Sad";
            } else {
              _currentColor = Colors.green;
              status = "Happy";
            }
            if (mylist[1] < 0.28) {
              status = "Dead";
            }
            if (userData.name == "-" || userData.name == "") {
              _topText = "Hi !";
            } else {
              _topText = 'Hi ' + userData.name + '!';
              username = userData.name;
            }

            indexes = userData.recoList;
            if (userData.petType == '') {
              return SafeArea(
                  child: Scaffold(
                      backgroundColor: primaryColour,
                      drawer: NavigationDrawerWidget(),
                      appBar: AppBar(
                        title: Text(_topText,
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
                                        width: 80,
                                        child: Image.asset('assets/world.png'),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('Welcome to Endangered Humans!',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: primaryColour,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Let's get you set up."),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('Click the Settings Button below.'),
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
              return SafeArea(
                child: Scaffold(
                  backgroundColor: primaryColour,
                  drawer: NavigationDrawerWidget(),
                  appBar: AppBar(
                    title:
                        Text(_topText, style: TextStyle(color: Colors.white)),
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
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Today's Footprint",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: primaryColour),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              userData.score.toStringAsFixed(2),
                                              style: TextStyle(
                                                  color: _currentColor,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "kg${"CO\u2082e"}",
                                              style: TextStyle(
                                                  color: primaryColour,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        OpenContainer(
                                          closedColor: primaryColour,
                                          openColor: primaryColour,
                                          middleColor: primaryColour,
                                          transitionDuration:
                                              Duration(milliseconds: 300),
                                          openBuilder: (context, _) =>
                                              CarbonFootprint(),
                                          closedBuilder: (context,
                                                  VoidCallback openContainer) =>
                                              ElevatedButton(
                                            style: ButtonStyle(
                                                elevation:
                                                    MaterialStatePropertyAll(0),
                                                minimumSize:
                                                    MaterialStatePropertyAll(
                                                        Size(110, 0)),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        primaryColour),
                                                textStyle:
                                                    MaterialStateProperty.all(
                                                        TextStyle(
                                                            color:
                                                                Colors.white))),
                                            child: Text(
                                              'Calculate',
                                            ),
                                            onPressed: openContainer,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        if (userData.petType != "") ...[
                                          FutureBuilder(
                                              future: storage.downloadURL(
                                                  userData.petType +
                                                      "/" +
                                                      status +
                                                      ".png"),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                        ConnectionState.done &&
                                                    snapshot.hasData) {
                                                  print(snapshot.data);
                                                  return InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      width: 100,
                                                      child: Image.network(
                                                        snapshot.data!,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                if (snapshot.connectionState ==
                                                        ConnectionState
                                                            .waiting ||
                                                    !snapshot.hasData) {
                                                  return Loading();
                                                }
                                                return Container();
                                              }),
                                        ],
                                        if (userData.petType == "") ...[
                                          Container(
                                            width: 80,
                                            child: Image.asset(
                                              'assets/world.png',
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ],
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Kill Count: ' +
                                            userData.killCount.toString())
                                      ],
                                    )
                                  ],
                                ))),
                        Card(
                            color: secondaryColour,
                            margin: EdgeInsets.all(16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            elevation: 10,
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Daily Goal",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColour),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        userData.goal.toString(),
                                        style: TextStyle(
                                            color: primaryColour, fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text("kg${"CO\u2082e"}",
                                          style: TextStyle(
                                              color: primaryColour,
                                              fontSize: 16)),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      OpenContainer(
                                        closedColor: primaryColour,
                                        openColor: primaryColour,
                                        middleColor: primaryColour,
                                        transitionDuration:
                                            Duration(milliseconds: 300),
                                        openBuilder: (context, _) =>
                                            RankingsPage(),
                                        closedBuilder: (context,
                                                VoidCallback openContainer) =>
                                            ElevatedButton(
                                          style: ButtonStyle(
                                              elevation:
                                                  MaterialStatePropertyAll(0),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      primaryColour),
                                              textStyle:
                                                  MaterialStateProperty.all(
                                                      TextStyle(
                                                          color:
                                                              Colors.white))),
                                          child: Text(
                                            'Rankings',
                                          ),
                                          onPressed: openContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FullChartPage()));
                                    },
                                    child: Container(
                                        width: 210,
                                        // height: 400,
                                        child: Column(
                                          children: [
                                            Text(
                                              '7 day progress',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryColour),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            LineChartPage(),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            )),
                        Card(
                          color: secondaryColour,
                          margin: EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          elevation: 10,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Recommendations",
                                    style: TextStyle(
                                        color: primaryColour,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(children: <Widget>[
                                    for (var item in indexes) ...[
                                      if (item != '') ...[
                                        ListTile(
                                          leading: Text(
                                            '*',
                                            style: TextStyle(
                                              color: primaryColour,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          title: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(item,
                                                    style: TextStyle(
                                                        fontSize: 14)),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              if (item == indexes[0]) ...[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      child: Image.asset(
                                                          'assets/food/Vegetables.png'),
                                                    ),
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                    Text(
                                                      '>',
                                                      style: TextStyle(
                                                          fontSize: 30),
                                                    ),
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                    if (item
                                                        .contains('Beef')) ...[
                                                      Container(
                                                        width: 50,
                                                        child: Image.asset(
                                                            'assets/food/Beef.png'),
                                                      )
                                                    ],
                                                    if (item
                                                        .contains('Pork')) ...[
                                                      Container(
                                                        width: 50,
                                                        child: Image.asset(
                                                            'assets/food/Bacon.png'),
                                                      )
                                                    ],
                                                    if (item.contains(
                                                        'Poultry')) ...[
                                                      Container(
                                                        width: 50,
                                                        child: Image.asset(
                                                            'assets/food/Poultry.png'),
                                                      )
                                                    ],
                                                    if (item.contains(
                                                        'Seafood')) ...[
                                                      Container(
                                                        width: 50,
                                                        child: Image.asset(
                                                            'assets/food/Seafood.png'),
                                                      )
                                                    ]
                                                  ],
                                                ),
                                              ]
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]
                                    ]
                                  ]),
                                  ListTile(
                                    leading: Text(
                                      "*",
                                      style: TextStyle(
                                        color: primaryColour,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    title: Column(
                                      children: [
                                        Text(
                                            'Recycle and earn money. Check out the Cash-for-Trash Stations in Singapore!',
                                            style: TextStyle(fontSize: 14)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          primaryColour),
                                                  textStyle:
                                                      MaterialStateProperty.all(
                                                          TextStyle(
                                                              color: Colors
                                                                  .white))),
                                              child: Text('Go to Map!'),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            GoogleMapsPage()));
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    leading: Text(
                                      "*",
                                      style: TextStyle(
                                        color: primaryColour,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    title: Text(element ?? 'Loading!',
                                        style: TextStyle(fontSize: 14)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  )),
                ),
              );
            }
          } else {
            return Loading();
          }
        });
  }
}
