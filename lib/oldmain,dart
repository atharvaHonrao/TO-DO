import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebase_options.dart';
import 'package:to_do_app/pages/Home_Page.dart';
import 'package:to_do_app/pages/Login_Page.dart';
import 'package:to_do_app/pages/Signup_Page.dart';
import 'package:to_do_app/pages/Todo_Page.dart';
import 'package:to_do_app/providers/User_Provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final dtabase = FirebaseDatabase.instance;
  
  @override
  Widget build(BuildContext context) {
    final ref = dtabase.ref();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider(""))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: "/",
        routes: {
          '/': (context) => TodoPage(),
          '/signup': (context) => SingupPage(),
          '/login': (context) => LoginPage(),
          '/todo': (context) => TodoPage(),
        },
      ),
    );
  }
}
