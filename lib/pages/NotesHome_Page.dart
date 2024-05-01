import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/ThemeProvider.dart';
import 'package:to_do_app/providers/User_Provider.dart';
import 'UploadNotesScreen.dart';

class NotesHomePage extends StatefulWidget {
  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (BuildContext context, val, Widget? child) => Scaffold(
        appBar: AppBar(
          title: Text('Study Buddy - Groups'),
          actions: [
            Switch(
              value: val.isSwitched,
              onChanged: (bool value) => {
                setState(() {
                  value = val.isSwitched;
                  val.updateTheme();
                })
              },
              activeTrackColor: Colors.grey,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 80,
                        // color: Color.fromRGBO(145, 118, 245, 1.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 10),
                      Text(
                        value.email,
                        style: TextStyle(
                          color: !val.isSwitched ? Colors.white : Colors.black,
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
                    Navigator.pop(context);
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.video_call),
                //   title: Text('Video Call'),
                //   onTap: () {
                //     Navigator.pushNamed(context, '/video');
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sign Out'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/');
                  },
                ),
              ],
            ),
          ),
        ),
        body: NotesGroupList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddGroupDialog(context),
          tooltip: 'Add Group',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _showAddGroupDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Group'),
          content: TextField(
            controller: _groupNameController,
            decoration: InputDecoration(hintText: 'Enter group name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                String groupName = _groupNameController.text.trim();
                if (groupName.isNotEmpty) {
                  await _addGroupToFirestore(groupName);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addGroupToFirestore(String groupName) async {
    try {
      await _firestore.collection('groups').add({
        'name': groupName,
        // Add more fields if needed
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Group added successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding group: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class NotesGroupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('groups').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> groupsDocs = snapshot.data!.docs;
        List groups = groupsDocs.map((doc) => doc['name'] ?? '').toList();

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UploadNotesScreen(group: groups[index]),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // color: Color.fromRGBO(145, 118, 245, 1.0),
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group,
                      size: 50,
                      color: Colors.white,
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
      },
    );
  }
}
