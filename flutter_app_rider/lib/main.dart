import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rider/Screens/loginpage.dart';
import 'package:flutter_app_rider/Screens/registrationpage.dart';
import 'package:flutter_app_rider/Screens/mainpage.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
      appId: '1:254791440826:android:c24718801102bbb55aa583',
      apiKey: 'AIzaSyDDRyLiiRSkJElnxSfzB-Girnf0TI4WcDE',
      projectId: 'flutter-rider-b6da9',
      messagingSenderId: '254791440826',
      databaseURL: 'https://flutter-rider-b6da9.firebaseio.com',
    )
        : FirebaseOptions(
      appId: '1:299634657812:android:6c17bee215041018917501',
      apiKey: 'AIzaSyCJsZjEh-_Tj22gQ-bTkF0sgrZa3jwwhgI',
      messagingSenderId: '299634657812',
      projectId: 'grider-19fbc',
      databaseURL: 'https://grider-19fbc.firebaseio.com',
    ),

  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Brand-Regular',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute:MainPage.id,
      routes: {
        RegistrationPage.id: (context) =>RegistrationPage(),
        LoginPage.id: (context) => LoginPage(),
        MainPage.id: (context) => MainPage(),
      },
    );
  }
}

//TODO : ADDING DATABASE FOR IOS LATER