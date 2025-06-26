import 'package:flutter/material.dart';
import 'package:pokedex/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poképedia Gen 2',
      theme: ThemeData(primarySwatch: Colors.red),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
