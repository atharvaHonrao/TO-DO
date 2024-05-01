import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebase_options.dart';
import 'package:to_do_app/pages/Login_Page.dart';
import 'package:to_do_app/pages/NotesHome_Page.dart';
import 'package:to_do_app/pages/Signup_Page.dart';
import 'package:to_do_app/pages/Video_Page.dart';
import 'package:to_do_app/providers/ThemeProvider.dart';
import 'package:to_do_app/providers/User_Provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  User? user = FirebaseAuth.instance.currentUser;
  String initialRoute = user != null ? '/home' : '/';
  print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${user?.email}");
  final String email;

  runApp(
    MyNotesApp(initialRoute: initialRoute, email: user?.email ?? ''),
  );
}

class MyNotesApp extends StatefulWidget {
  final String initialRoute;
  final String email;

  const MyNotesApp({Key? key, required this.initialRoute, required this.email})
      : super(key: key);
  @override
  State<MyNotesApp> createState() => _MyNotesAppState();
}

class _MyNotesAppState extends State<MyNotesApp> {
  final dtabase = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    // final ref = dtabase.ref();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(widget.email),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, value, Widget? child) => MaterialApp(
          theme: value.isSwitched
              ? ThemeData(
                  useMaterial3: true,
                  // primaryColor: Colors.red,
                )
              : ThemeData(
                  useMaterial3: true,
                  brightness: Brightness.dark,
                ),
          title: 'Flutter Demo',
          initialRoute: widget.initialRoute,
          debugShowCheckedModeBanner: false,
          routes: {
            '/home': (context) => NotesHomePage(),
            '/signup': (context) => SingupPage(),
            '/': (context) => LoginPage(),
            '/video': (context) => VideoPage(),
          },
        ),
      ),
    );
  }
}
