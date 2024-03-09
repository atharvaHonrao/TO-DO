import 'package:firebase_core/firebase_core.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider(""))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: "/signup",
        routes: {
          '/': (context) => HomePage(),
          '/signup': (context) => SingupPage(),
          '/login': (context) => LoginPage(),
          '/todo': (context) => TodoPage(),
        },
      ),
    );
  }
}
