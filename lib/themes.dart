import 'package:flutter/material.dart';

final ThemeData numerologyTheme = ThemeData(
  primarySwatch: Colors.teal,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.teal,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 18.0, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black54),
    headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.teal),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.teal, width: 2.0),
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    ),
  ),
);
