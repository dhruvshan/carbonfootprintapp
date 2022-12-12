import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/homepage.dart';
import 'package:flutter_application_1/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/myuser.dart';
import 'package:flutter_application_1/services/database.dart';

class LineChartPage extends StatefulWidget {
  const LineChartPage({Key? key}) : super(key: key);

  @override
  State<LineChartPage> createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  var myscore;
  List<FlSpot> myMap = [];
  // var myArray = [];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            myscore = userData?.scoreProgress;
            myscore = List<double>.from(myscore);
            if (myscore.length < 1) {
              return Container(
                width: 150,
                child: const Text('No score calculated yet!'),
              );
            } else {
              if (myscore.length >= 7) {
                myscore = myscore.sublist(myscore.length - 7);
              }
              myMap = [];
              myscore.asMap().forEach((i, x) {
                myMap.insert(i, FlSpot(double.parse((i + 1).toString()), x));
              });
              return AspectRatio(
                aspectRatio: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LineChart(
                    LineChartData(
                        maxX: 7,
                        backgroundColor: primaryColour,
                        minY: 0,
                        minX: 1,
                        lineBarsData: [
                          LineChartBarData(
                              spots: [
                                FlSpot(1, userData!.goal.toDouble()),
                                FlSpot(2, userData.goal.toDouble()),
                                FlSpot(3, userData.goal.toDouble()),
                                FlSpot(4, userData.goal.toDouble()),
                                FlSpot(5, userData.goal.toDouble()),
                                FlSpot(6, userData.goal.toDouble()),
                                FlSpot(7, userData.goal.toDouble())
                              ],
                              isStepLineChart: false,
                              isCurved: true,
                              dotData: FlDotData(show: false),
                              color: secondaryColour),
                          LineChartBarData(
                              spots: myMap,
                              isCurved: false,
                              dotData: FlDotData(show: true),
                              color: Colors.orange),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            axisNameWidget: Text(
                              'kgCO2e',
                              style: TextStyle(height: -0.5),
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        )),
                    swapAnimationDuration: const Duration(milliseconds: 550),
                  ),
                ),
              );
            }
          } else {
            return Loading();
          }
        });
  }
}
