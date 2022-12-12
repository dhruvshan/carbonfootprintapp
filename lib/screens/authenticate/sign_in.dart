import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/authenticate/forgotpassword.dart';
import 'package:flutter_application_1/screens/home/homepage.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/shared/constants.dart';
import 'package:flutter_application_1/shared/loading.dart';

class SignIn extends StatefulWidget {
  //const SignIn({Key? key}) : super(key: key);
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 7, 35, 10),
                Color.fromARGB(255, 45, 54, 44),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                title: const Text(
                  'Login',
                  style: TextStyle(color: secondaryColour),
                ),
                automaticallyImplyLeading: false,
              ),
              body: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const AnimatedImage(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 50.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 20.0),
                            TextFormField(
                              style: const TextStyle(color: secondaryColour),
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Email'),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter an email';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                if (val != "") {
                                  setState(() {
                                    email = val;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              style: const TextStyle(color: secondaryColour),
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Password'),
                              obscureText: true,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                            ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              child: const Text('Sign in'),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(primaryColour),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(color: Colors.white))),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);
                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'Could not sign in with those credentials!';
                                      loading = false;
                                    });
                                  }
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            GestureDetector(
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: Color.fromARGB(238, 248, 240, 227)),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage(),
                                ));
                              },
                            ),
                            // GoogleButton(),
                            const SizedBox(height: 12.0),
                            Text(
                              error,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0),
                            ),
                            const SizedBox(height: 12.0),
                            TextButton.icon(
                                onPressed: () {
                                  widget.toggleView();
                                },
                                icon: const Icon(
                                  Icons.app_registration_rounded,
                                  color: Colors.white,
                                ),
                                label: const Text('New here? Register',
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            238, 248, 240, 227)))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class AnimatedImage extends StatefulWidget {
  const AnimatedImage({Key? key}) : super(key: key);

  @override
  State<AnimatedImage> createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 3))
        ..repeat(reverse: true);
  late Animation<Offset> _animation = Tween(
    begin: Offset.zero,
    end: Offset(0, 0.08),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Image.asset(
        'assets/world.png',
        height: 100,
      ),
    );
  }
}
