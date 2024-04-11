import 'package:flutter/material.dart';

ThemeData get buttonStyleTheme => ThemeData(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 8.0,
          shadowColor: Colors.green,
          backgroundColor: Colors.green,
          disabledBackgroundColor: Colors.green.withOpacity(0.4),
          disabledForegroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          textStyle:
              const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.green, width: 1.5),
          disabledForegroundColor: Colors.grey,
          foregroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          textStyle:
              const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
