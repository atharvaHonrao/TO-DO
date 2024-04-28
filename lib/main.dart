import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebase_options.dart';
import 'package:to_do_app/pages/Login_Page.dart';
import 'package:to_do_app/pages/Signup_Page.dart';
import 'package:to_do_app/pages/Video_Page.dart';
import 'package:to_do_app/providers/ThemeProvider.dart';
import 'package:to_do_app/providers/User_Provider.dart';
import 'UploadNotesScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyNotesApp());
}

class MyNotesApp extends StatefulWidget {
  @override
  State<MyNotesApp> createState() => _MyNotesAppState();
}

class _MyNotesAppState extends State<MyNotesApp> {
  final dtabase = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    final ref = dtabase.ref();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(""),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, value, Widget? child) => MaterialApp(
          theme: value.isSwitched
              ? ThemeData(
                  primaryColor: Colors.red,
                )
              : ThemeData(
                  brightness: Brightness.dark,
                ),
          title: 'Flutter Demo',
          initialRoute: "/",
          debugShowCheckedModeBanner: false,
          routes: {
            '/home': (context) => NotesHomePage(),
            '/signup': (context) => SingupPage(),
            '/': (context) => LoginPage(),
            '/video': (context) => VideoPage(),
            // '/todo': (context) => TodoPage(),
          },
        ),
      ),
    );
  }
}

class NotesHomePage extends StatefulWidget {
  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (BuildContext context, val, Widget? child) => Scaffold(
        appBar: AppBar(
          title: Text('Notes Groups'),
          actions: [
            Switch(
              value: val.isSwitched,
              onChanged: (bool value) => {
                setState(() => {
                      value = val.isSwitched,
                      val.updateUsername(),
                    })
              },
              activeTrackColor: Colors.white,
              activeColor: Colors.white,
            ),
          ],
        ),
        drawer: Consumer<UserProvider>(
          builder: (BuildContext context, value, Widget? child) => Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 80,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        value.email, // Display user's name or username here
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pop(context);                  },
                ),
                ListTile(
                  leading: Icon(Icons.video_call),
                  title: Text('Video Call'),
                  onTap: () {
                    Navigator.pushNamed(context,'/video');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sign Out'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/'); // Close the drawer
                    // Navigate to login or another appropriate screen
                  },
                ),
              ],
            ),
          ),
        ),
        body: NotesGroupList(),
      ),
    );
  }
}

class NotesGroupList extends StatelessWidget {
  final List<String> groups = ['Chemistry', 'Physics', 'Maths'];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns in the grid
        crossAxisSpacing: 10, // Spacing between columns
        mainAxisSpacing: 10, // Spacing between rows
        childAspectRatio: 1, // Aspect ratio (width / height) of each grid item
      ),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UploadNotesScreen(group: groups[index]),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue, // Placeholder color for the tile background
              borderRadius:
                  BorderRadius.circular(10), // Rounded corners for the tile
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.group, // Default group icon
                  size: 50, // Icon size
                  color: Colors.white, // Icon color
                ),
                SizedBox(height: 10),
                Text(
                  groups[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
