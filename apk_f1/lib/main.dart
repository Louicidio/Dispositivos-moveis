import 'package:flutter/material.dart';
import 'package:apk_formula1/view/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: Colors.white,
        primaryColor: Colors.red[900],
        scaffoldBackgroundColor: Colors.grey[900],
      ),
    ),
  );
}
