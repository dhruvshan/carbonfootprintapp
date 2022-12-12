import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/homepage.dart';
import 'package:flutter_application_1/screens/widget/navigation_drawer_widget.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../shared/extensions.dart';

Future<List<News>> fetchNews() async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/everything?q=CO2&apiKey=24c5e88f1fba4dba9deb45b8ec3f3d3a'));

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body)['articles'];
    return jsonResponse.map((data) => new News.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}

class News {
  final String? description;
  final String title;
  final String? imgUrl;
  final String url;

  const News({
    required this.description,
    required this.title,
    required this.imgUrl,
    required this.url,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
        description: json['description'],
        title: json['title'],
        imgUrl: json['urlToImage'],
        url: json['url'],
      );
}

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<News>> futureNews;
  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColour,
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('News Feed', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: primaryColour,
        ),
        body: Center(
          child: FutureBuilder<List<News>>(
            future: futureNews,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<News> data = snapshot.data!;

                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.all(8.0),
                          margin:
                              const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
                          decoration: BoxDecoration(
                              color: secondaryColour,
                              border: Border.all(
                                  color: Color.fromARGB(51, 114, 114, 114)),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(children: [
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (data[index].imgUrl == null) ...[
                                    Container(
                                        child: Image.asset('assets/world.png'),
                                        width: 60.0),
                                  ],
                                  if (data[index].imgUrl != null) ...[
                                    ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        child: Image.network(
                                          data[index].imgUrl.toString(),
                                          width: 130,
                                        )),
                                  ],
                                  SizedBox(width: 20.0),
                                  Expanded(
                                    child: Text(
                                      data[index].title,
                                      style: TextStyle(color: primaryColour),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ),
                        onTap: () async {
                          if (await launchUrlString(data[index].url)) {
                            await launchUrl(
                              Uri.parse(data[index].url),
                              mode: LaunchMode.inAppWebView,
                            );
                          } else {
                            throw 'Could not launch';
                          }
                        },
                      );
                    });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator(
                color: Color.fromARGB(255, 158, 170, 144),
              );
            },
          ),
        ));
  }
}
