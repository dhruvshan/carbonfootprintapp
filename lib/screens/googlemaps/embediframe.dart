import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/screens/home/homepage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: primaryColour,
      ),
      body: Column(
        children: [
          Expanded(
            child: WebView(
              initialUrl:
                  'https://data.gov.sg/dataset/cash-for-trash/resource/122c59df-04e8-4247-a864-f2386db9a907/view/c02c17c2-db5a-4778-acc1-6887bd416c97',
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        ],
      ),
    );
  }
}
