import 'package:flutter/material.dart';

class MainTheme {
  static ThemeData getTheme() {
    return ThemeData(
        fontFamily: "Sofia Pro",
        primaryColor: Color(0xff5f5fd3),
        primaryColorLight: Color(0xff5f6ed3),
        backgroundColor: Colors.white,
        buttonTheme: ButtonThemeData(buttonColor: Colors.deepOrangeAccent, textTheme: ButtonTextTheme.primary));
  }
}
