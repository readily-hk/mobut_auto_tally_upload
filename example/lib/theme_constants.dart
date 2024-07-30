import 'package:flutter/material.dart';

Color grassGreen = Color(0xFF5F9F6D);
Color lightRed = Color(0xFFE79473);

ThemeData theme = ThemeData(
    fontFamily: 'NotoSansTC',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF000000))),
    ));
