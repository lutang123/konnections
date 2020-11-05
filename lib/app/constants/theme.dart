import 'package:flutter/material.dart';

const Color darkThemeButtonColor = Color(0xf0ffcb74);
const Color lightThemeButtonColor = Color(0xFF006a71); //button. icon

const Color darkThemeWordsColor = Colors.white;
const Color lightThemeWordsColor = Colors.black87;

const Color darkThemeBkgdColor = Color(0xFF2D2F41); //f4f9f4
const Color lightThemeBkgdColor = Color(0xfff4f9f4); //Color(0xfffffafa)

///Light theme
final ThemeData lightTheme = ThemeData.light().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: lightThemeBkgdColor,
  appBarTheme:
      AppBarTheme(color: lightThemeBkgdColor, brightness: Brightness.light),
  buttonColor: lightThemeButtonColor,
  accentColor: lightThemeButtonColor,
  cursorColor: lightThemeWordsColor,
  iconTheme: IconThemeData(color: lightThemeButtonColor),
  textTheme: TextTheme(
    headline5:
        TextStyle(color: lightThemeWordsColor, fontWeight: FontWeight.w400),
    headline6:
        TextStyle(color: lightThemeWordsColor, fontWeight: FontWeight.w400),

    subtitle1: TextStyle(
        color: lightThemeWordsColor,
        fontWeight: FontWeight.w400,
        fontSize: 18.0),

    subtitle2: TextStyle(
        fontWeight: FontWeight.w400,
        color: lightThemeWordsColor,
        fontStyle: FontStyle.italic,
        fontSize: 17),

    bodyText1: TextStyle(fontSize: 16, color: lightThemeWordsColor), //16

    bodyText2: TextStyle(
        fontSize: 15,
        color: lightThemeWordsColor,
        fontStyle: FontStyle.italic), //14
  ),
  dialogBackgroundColor: lightThemeBkgdColor,
  dialogTheme: DialogTheme(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)))),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: darkThemeBkgdColor,
  appBarTheme:
      AppBarTheme(color: darkThemeBkgdColor, brightness: Brightness.dark),
  buttonColor: darkThemeButtonColor,
  accentColor: darkThemeButtonColor, //e.g. container box decoration
  // canvasColor: Colors.transparent, //e.g. button color
  cursorColor: darkThemeWordsColor,
  iconTheme: IconThemeData(color: darkThemeButtonColor),
  textSelectionColor: darkThemeBkgdColor,
  unselectedWidgetColor: Colors.white,

  textTheme: TextTheme(
    ///todoList title, add todo title
    headline5: TextStyle(
        //24
        color: darkThemeWordsColor,
        fontWeight: FontWeight.w400),
    headline6:
        TextStyle(color: darkThemeWordsColor, fontWeight: FontWeight.w400),

    subtitle1: TextStyle(
        fontWeight: FontWeight.w400,
        color: darkThemeWordsColor,
        fontSize: 18.0),

    subtitle2: TextStyle(
        fontWeight: FontWeight.w400,
        color: darkThemeWordsColor,
        fontStyle: FontStyle.italic,
        fontSize: 17),

    bodyText1: TextStyle(fontSize: 16, color: darkThemeWordsColor), //16

    bodyText2: TextStyle(
        fontSize: 15,
        color: darkThemeWordsColor,
        fontStyle: FontStyle.italic), //14
  ),

  dialogBackgroundColor: darkThemeBkgdColor,
  dialogTheme: DialogTheme(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)))),
);

//NAME         SIZE  WEIGHT  SPACING
//headline1    96.0  light   -1.5
//headline2    60.0  light   -0.5
//headline3    48.0  regular  0.0
//headline4    34.0  regular  0.25
//headline5    24.0  regular  0.0
//headline6    20.0  medium   0.15
//subtitle1    16.0  regular  0.15
//subtitle2    14.0  medium   0.1
//bodyText1    16.0  regular  0.5
//bodyText2    14.0  regular  0.25
//button       14.0  medium   1.25
//caption      12.0  regular  0.4
//overline     10.0  regular  1.5

const Color themeColor0 = Color(0xf000b7c2);
const Color themeColor = Color(0xf01aa6b7);
const Color themeColor2 = Color(0xf0ffcb74);

const Color themeColor3 = Color(0xf000bcd4);
const Color themeColor4 = Color(0xf000b7c2);
const Color themeColor5 = Color(0xf001a9b4);
const Color themeColor6 = Color(0xf05fdde5);

const Color themeColor7 = Color(0xf040bad5);
const Color themeColor8 = Color(0xf0fcbf1e);

const Color themeColor9 = Color(0xf05fdde5);
const Color themeColor10 = Color(0xf0c);

const Color themeColor11 = Color(0xf000b7c2);
const Color themeColor12 = Color(0xf0fdcb9e);
