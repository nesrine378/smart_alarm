import 'package:flutter/material.dart';
import 'package:app/Authentification/SignupPage.dart';
import 'AddProfilePage.dart';
import 'Authentification/LoginPage.dart';
import 'HomePage.dart';


void main() {
  runApp( SmartAlarmApp() );
}

class SmartAlarmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smart Alarm App",
      theme: ThemeData(
        primarySwatch: Colors.pink
        
      ),
    home: LoginPage(),

    );
  }
}

