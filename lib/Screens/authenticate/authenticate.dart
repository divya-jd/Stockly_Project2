import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  // Track whether to show Sign-In or Register screen
  bool showSignIn = true;

  // Toggle between Sign-In and Register views
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300), // Smooth transition between screens
      child: showSignIn
          ? SignIn(toggleView: toggleView, key: const ValueKey('SignIn'))
          : Register(toggleView: toggleView, key: const ValueKey('Register')),
    );
  }
}
