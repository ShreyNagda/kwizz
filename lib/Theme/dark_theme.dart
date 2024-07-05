import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: GoogleFonts.latoTextTheme().apply(
    displayColor: Colors.white,
    bodyColor: Colors.white,
  ),
  dropdownMenuTheme: const DropdownMenuThemeData(
    textStyle: TextStyle(color: Colors.white),
  ),
);
