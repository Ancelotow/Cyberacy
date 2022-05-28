// ignore_for_file: prefer_const_constructors

import 'package:bo_cyberacy/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyberacy',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 73, 150, 221),
        backgroundColor: Color.fromARGB(255, 141, 142, 142),
        disabledColor: Color.fromARGB(255, 210, 210, 210),
        buttonColor: Color.fromARGB(255, 0, 0, 255),
        hoverColor: Color.fromARGB(255, 112, 171, 225),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.white,
            fontFamily: "HK-Nova",
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            color: Colors.black,
            fontFamily: "HK-Nova",
            fontSize: 14
          ),
          button: TextStyle(
              color: Colors.white,
              fontFamily: "HK-Nova",
              fontSize: 14
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          contentPadding: EdgeInsets.all(8.00)
        ),
      ),
      home: const HomePage(),
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPage(),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
