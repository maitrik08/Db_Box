import 'package:db_box/Controller/themeController.dart';
import 'package:flutter/material.dart';
class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            PreferencesController.setIntroSeen();
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Text('Get Started'),
        ),
      ),
    );
  }
}
