import 'package:flutter/material.dart';
import 'package:konnections/app/constants/theme.dart';

/// TextStyle
///

const KSignInTitle =
    TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold);

const KTextWarning = TextStyle(color: Colors.red, fontSize: 16);

const KTextButton = TextStyle(
  color: Colors.blue,
  fontSize: 16,
  fontStyle: FontStyle.italic,
  decoration: TextDecoration.underline,
);

const KError = TextStyle(
  color: lightThemeWordsColor,
  fontSize: 16,
  fontStyle: FontStyle.italic,
);

/// sign in screen
// google, apple, explore
const KSignInButton = TextStyle(
  fontSize: 20,
  color: lightThemeWordsColor,
  fontWeight: FontWeight.w600,
  fontFamily: "varelaRound",
);

/// for dialog:
const KDialogButton =
    TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 17);

const KFlushBarTitle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
    color: Colors.white,
    fontFamily: "ShadowsIntoLightTwo");

const KFlushBarTitleHighlight = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    color: Colors.white,
    fontStyle: FontStyle.italic,
    fontFamily: "ShadowsIntoLightTwo");

const KFlushBarMessage = TextStyle(
    fontSize: 15.0,
    color: Colors.white,
    fontStyle: FontStyle.italic,
    fontFamily: "ShadowsIntoLightTwo");

const KFlushBarGradient =
    LinearGradient(colors: [Color(0xF00f4c75), Color(0xF03282b8)]);

/// Gradient
const KBackgroundGradient = LinearGradient(
  colors: [
    Colors.transparent, //we can not add with opacity
    Colors.black12,
  ],
  stops: [0.5, 1.0],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  tileMode: TileMode.repeated,
);

const KBackgroundGradientDark = LinearGradient(
  colors: [
    Colors.black12, //we can not add with opacity
    Colors.black26,
  ],
  stops: [0.5, 1.0],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  tileMode: TileMode.repeated,
);

/// InputDecoration
///in HomeTextField (home and name)
const KHomeTextFieldInputDecoration = InputDecoration(
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
    color: Colors.white,
  )),

  ///validator can't show when over the max length
  // counterText: "",
);

///in AddTodo date
const KTransparentInputDecoration = InputDecoration(
  focusedBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
  enabledBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
);
