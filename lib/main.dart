import 'package:flutter/material.dart';
import 'package:to_do_app/pages/Home_Page.dart';
import 'package:to_do_app/pages/Login_Page.dart';
import 'package:to_do_app/pages/Signup_Page.dart';
import 'package:to_do_app/pages/Todo_Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/login",
      routes: {
        '/': (context) => HomePage(),
        '/signup': (context) => SingupPage(),
        '/login': (context) => LoginPage(),
        '/todo': (context) => TodoPage(),
      },
    );
  }
}
