// ignore_for_file: prefer_const_constructors
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bo_cyberacy/models/entities/manifestation.dart';
import 'package:bo_cyberacy/pages/login_page.dart';
import 'package:bo_cyberacy/pages/manifestation/add_manifestation.dart';
import 'package:bo_cyberacy/pages/manifestation/manifestation_details.dart';
import 'package:bo_cyberacy/pages/navigation_page.dart';
import 'package:bo_cyberacy/pages/party/add_party_page.dart';
import 'package:bo_cyberacy/pages/screen_404.dart';
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
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: const [Locale('fr')],
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 54, 54, 54),
        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
        disabledColor: const Color.fromARGB(255, 84, 83, 83),
        cardColor: const Color.fromARGB(255, 54, 54, 54),
        buttonColor: const Color.fromARGB(255, 13, 41, 134),
        hoverColor: const Color.fromARGB(255, 81, 37, 154),
        accentColor: const Color.fromARGB(255, 52, 95, 255),
        highlightColor: const Color.fromARGB(255, 140, 35, 241),
        focusColor: const Color.fromARGB(255, 150, 93, 197),
        unselectedWidgetColor: const Color.fromARGB(255, 133, 133, 133),
        shadowColor: const Color.fromARGB(121, 121, 121, 121),
        bottomAppBarColor: const Color.fromARGB(255, 54, 54, 54),
        hintColor: const Color.fromARGB(255, 169, 165, 176),
        cursorColor: Colors.white,
        textTheme: _getTextThemeDark(context),
        inputDecorationTheme: _getInputDecorationThemeDark(context),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 58, 114, 211),
        backgroundColor: const Color.fromARGB(255, 232, 232, 232),
        disabledColor: const Color.fromARGB(255, 210, 210, 210),
        cardColor: const Color.fromARGB(255, 218, 217, 217),
        buttonColor: const Color.fromARGB(255, 36, 75, 215),
        hoverColor: const Color.fromARGB(255, 21, 71, 110),
        accentColor: const Color.fromARGB(255, 252, 252, 252),
        highlightColor: const Color.fromARGB(255, 0, 69, 246),
        focusColor: const Color.fromARGB(255, 68, 94, 197),
        unselectedWidgetColor: const Color.fromARGB(255, 182, 181, 181),
        shadowColor: const Color.fromARGB(121, 89, 89, 89),
        bottomAppBarColor: const Color.fromARGB(255, 58, 114, 211),
        hintColor: Colors.black,
        cursorColor: const Color.fromARGB(255, 0, 69, 246),
        textTheme: _getTextThemeLight(context),
        inputDecorationTheme: _getInputDecorationThemeLight(context),
      ),
      routes: {
        NavigationPage.routeName: (BuildContext context) => NavigationPage(),
        AddPartyPage.routeName: (BuildContext context) => AddPartyPage(),
        AddManifestationPage.routeName: (BuildContext context) =>
            AddManifestationPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final dynamic arguments = settings.arguments;
        switch (settings.name) {
          case ManifestationDetail.routeName:
            Manifestation manifestation;
            if (arguments is Manifestation) {
              manifestation = arguments;
              return MaterialPageRoute(
                builder: (BuildContext context) =>
                    ManifestationDetail(manifestation: manifestation),
              );
            } else {
              return MaterialPageRoute(
                  builder: (BuildContext context) => Screen404());
            }

          default:
            return MaterialPageRoute(
                builder: (BuildContext context) => Screen404());
        }
      },
      home: const HomePage(),
    );
  }

  TextTheme _getTextThemeDark(BuildContext context) {
    return TextTheme(
        headline1: TextStyle(
          color: Colors.white,
          fontFamily: "HK-Nova",
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
        headline2: TextStyle(
          color: Theme.of(context).accentColor,
          fontFamily: "HK-Nova",
          fontSize: 28,
        ),
        headline3: TextStyle(
          color: Colors.white,
          fontFamily: "HK-Nova",
          fontSize: 20,
          fontWeight: FontWeight.w100,
        ),
        headline4: TextStyle(
          color: Colors.white,
          fontFamily: "HK-Nova",
          fontSize: 20,
        ),
        bodyText1: TextStyle(
          color: Colors.white,
          fontFamily: "HK-Nova",
          fontSize: 14,
        ),
        bodyText2: TextStyle(
          color: Colors.white,
          fontFamily: "HK-Nova",
          fontSize: 14,
        ),
        caption: TextStyle(
          color: Colors.grey,
          fontFamily: "HK-Nova",
          fontSize: 12,
        ),
        button: TextStyle(
          color: Colors.white,
          fontFamily: "HK-Nova",
          fontSize: 14,
        ),
        labelMedium: TextStyle(
          color: Colors.white,
          fontFamily: "HK-Nova",
          fontSize: 14,
        ));
  }

  TextTheme _getTextThemeLight(BuildContext context) {
    return TextTheme(
      headline1: TextStyle(
        color: Colors.black,
        fontFamily: "HK-Nova",
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: Theme.of(context).accentColor,
        fontFamily: "HK-Nova",
        fontSize: 28,
      ),
      headline3: TextStyle(
        color: Colors.black,
        fontFamily: "HK-Nova",
        fontSize: 20,
        fontWeight: FontWeight.w100,
      ),
      headline4: TextStyle(
        color: Colors.white,
        fontFamily: "HK-Nova",
        fontSize: 20,
      ),
      bodyText1: TextStyle(
        color: Colors.black,
        fontFamily: "HK-Nova",
        fontSize: 14,
      ),
      bodyText2: TextStyle(
        color: Colors.black,
        fontFamily: "HK-Nova",
        fontSize: 14,
      ),
      caption: TextStyle(
        color: const Color.fromARGB(255, 75, 75, 75),
        fontFamily: "HK-Nova",
        fontSize: 12,
      ),
      button: TextStyle(
        color: Colors.white,
        fontFamily: "HK-Nova",
        fontSize: 14,
      ),
    );
  }

  InputDecorationTheme _getInputDecorationThemeLight(BuildContext context) {
    return InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: const Color.fromARGB(255, 0, 0, 0),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.00),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: const Color.fromARGB(255, 0, 42, 255),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.00),
      ),
      filled: true,
      contentPadding: EdgeInsets.all(8.00),
      hoverColor: Colors.transparent,
    );
  }

  InputDecorationTheme _getInputDecorationThemeDark(BuildContext context) {
    return InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: const Color.fromARGB(255, 169, 165, 176),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.00),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: const Color.fromARGB(255, 132, 0, 255),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.00),
      ),
      filled: true,
      contentPadding: EdgeInsets.all(8.00),
      hoverColor: Colors.transparent,
    );
  }

}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}
