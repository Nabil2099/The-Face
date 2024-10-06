import 'package:flutter/material.dart';
import 'package:flutter/material.dart%20';
import 'auth/auth.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  // Helper method to access state from anywhere in the app
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  // Initially set the theme mode to light
  ThemeMode _themeMode = ThemeMode.light;

  // Method to toggle between light and dark mode
  void toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme, // Light theme
      darkTheme: darkTheme, // Dark theme
      themeMode: _themeMode, // Dynamic theme mode
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}