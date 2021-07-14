import 'package:flutter/material.dart';

class MainTheme {
  static ThemeData getTheme() {
    return ThemeData(
        fontFamily: "Nunito",
        primaryColor: Colors.deepOrangeAccent,
        backgroundColor: Colors.white,
        buttonTheme: ButtonThemeData(buttonColor: Colors.deepOrangeAccent, textTheme: ButtonTextTheme.primary));
  }


}