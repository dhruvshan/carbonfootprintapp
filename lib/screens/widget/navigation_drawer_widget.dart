import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/authenticate/authenticate.dart';
import 'package:flutter_application_1/screens/authenticate/sign_in.dart';
import 'package:flutter_application_1/screens/settings/settings.dart';
import 'package:flutter_application_1/screens/wrapper.dart';
import 'package:flutter_application_1/services/auth.dart';

class NavigationDrawerWidget extends StatelessWidget {
  NavigationDrawerWidget({Key? key}) : super(key: key);
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color.fromARGB(255, 35, 59, 37),
        child: ListView(padding: padding, children: <Widget>[
          SizedBox(height: 48),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('My Profile', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          SizedBox(height: 24),
          Divider(color: Colors.white70),
          SizedBox(height: 24),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () async {
              await _auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/wrapper', (_) => false);
            },
          )
        ]),
      ),
    );
  }
}
