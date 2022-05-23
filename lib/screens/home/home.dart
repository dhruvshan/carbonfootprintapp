import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/widget/navigation_drawer_widget.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('Endangered Humans'),
          backgroundColor: Colors.lightBlue[400],
          centerTitle: true,
          elevation: 0.0,
          // actions: <Widget>[
          //   TextButton.icon(
          //     icon: Icon(Icons.person),
          //     label: Text('logout'),
          //     onPressed: () async {
          //       await _auth.signOut();
          //     },
          //   )
          // ],
        ));
  }
}
