import 'package:flutter/material.dart';
import './ui/todo_screen.dart';
import './ui/add_subject.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => todoScreen(),
        '/addListScreen': (context) => addListScreen()
      },
    );
  }
}