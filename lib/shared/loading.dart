import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 7, 35, 10),
      child: Center(
          child: SpinKitChasingDots(
        color: Color.fromARGB(238, 248, 240, 227),
        size: 50.0,
      )),
    );
  }
}
