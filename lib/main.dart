import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:db_box/Controller/todoController.dart';
import 'package:db_box/Controller/themeController.dart';
import 'package:db_box/View/homeScreen.dart';
import 'package:db_box/View/introScreen.dart';
import 'package:db_box/View/splashScreen.dart';

void main() {
  runApp(DBBoxApp());
}

class DBBoxApp extends StatefulWidget {
  @override
  _DBBoxAppState createState() => _DBBoxAppState();
}

class _DBBoxAppState extends State<DBBoxApp> {
  bool _isDarkTheme = false;

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkTheme = isDark;
    });
    PreferencesController.setTheme(isDark); // Assuming this saves the theme preference
  }

  @override
  void initState() {
    super.initState();
    PreferencesController.getTheme().then((value) {
      setState(() {
        _isDarkTheme = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoController()), // Add the TodoController provider
        // You can add other providers here if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
        routes: {
          '/': (context) => SplashScreen(),
          '/intro': (context) => IntroScreen(),
          '/home': (context) => HomeScreen(onThemeChanged: _toggleTheme, isDarkTheme: _isDarkTheme),
        },
      ),
    );
  }
}
