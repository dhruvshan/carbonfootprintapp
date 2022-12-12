import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter_application_1/screens/wrapper.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  static String id = 'OnBoardingPage';
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  _storeOnBoardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
  }

  @override
  Widget build(BuildContext context) => SafeArea(
          child: IntroductionScreen(
              pages: [
            PageViewModel(
                decoration: PageDecoration(
                    titleTextStyle:
                        TextStyle(color: Colors.white, fontSize: 20),
                    bodyTextStyle:
                        TextStyle(color: Colors.white, fontSize: 18)),
                title: 'Welcome to Endangered Humans',
                body:
                    'This application was built to provide you with an effective carbon footprint calculator.',
                image: Image.asset(
                  'assets/world.png',
                  width: 150,
                )),
            PageViewModel(
                decoration: PageDecoration(
                    titleTextStyle:
                        TextStyle(color: Colors.white, fontSize: 20),
                    bodyTextStyle:
                        TextStyle(color: Colors.white, fontSize: 18)),
                title: 'Stay Updated',
                body:
                    'But we don\'t just calculate, we give you recommendations and provide you with news about how your impact could change the lives of others.',
                image: Image.asset(
                  'assets/gw128.png',
                  width: 150,
                )),
            PageViewModel(
                decoration: PageDecoration(
                    titleTextStyle:
                        TextStyle(color: Colors.white, fontSize: 20),
                    bodyTextStyle:
                        TextStyle(color: Colors.white, fontSize: 18)),
                title: 'Choose your friend',
                body:
                    'You are never alone in this journey. Select a pet in your profile page and see how your carbon footprint can both positively and negatively impact your new friend.',
                image: Image.asset(
                  'assets/combined.png',
                  width: 200,
                )),
          ],
              done: Text(
                'Next',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              onDone: () async {
                await _storeOnBoardInfo();
                goToHome(context);
              },
              showSkipButton: true,
              skip: Text(
                'Skip',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(238, 248, 240, 227),
                ),
              ),
              onSkip: () async {
                await _storeOnBoardInfo();
                goToHome(context);
              },
              next: Icon(
                Icons.arrow_forward,
                color: Colors.orange,
              ),
              globalBackgroundColor: Color.fromARGB(
                255,
                7,
                35,
                10,
              )));

  void goToHome(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Wrapper()),
      );

  Widget buildImage(String path) => (Center(
        child: Image.asset(
          path,
          width: 350,
        ),
      ));

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        bodyTextStyle: TextStyle(fontSize: 20, color: Colors.white),
        imagePadding: EdgeInsets.all(24),
      );
}
