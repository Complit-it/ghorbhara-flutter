import 'package:flutter/material.dart';
import 'package:hello_world/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'welcome_pg.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Your splash screen content here
      ),
    );
  }
}

class SplashScreenWithCheck extends StatefulWidget {
  @override
  _SplashScreenWithCheckState createState() => _SplashScreenWithCheckState();
}

class _SplashScreenWithCheckState extends State<SplashScreenWithCheck> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('google_id');
    if (token != null && token.isNotEmpty) {
      _navigateToHome();
    } else {
      _navigateToSignIn();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  void _navigateToSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomePg()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: SplashScreenWithCheck(),
//   ));
// }
