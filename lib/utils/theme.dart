import 'package:flutter/material.dart';

class AppTheme {
  // Define your color palette
  static const Color primaryColor = Color.fromRGBO(238, 238, 238,1);  // Example blue color
  static const Color secondaryColor = Color.fromRGBO(255, 255, 255,1);  // Example red color
 static const Color blackLight=Colors.black26;

  static const Color backgroundColor = Color.fromRGBO(255, 255, 255,1);  // Example light grey
  static const Color textColor = Color(0xFF212121);

  // Define your text styles
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
    displayMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
  );

  // Define your theme data
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    textTheme: textTheme,
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
  );


}
