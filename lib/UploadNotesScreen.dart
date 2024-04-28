import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'files_list_screen.dart'; // Import the FilesListScreen widget

class UploadNotesScreen extends StatefulWidget {
  final String group;

  UploadNotesScreen({required this.group});

  @override
  _UploadNotesScreenState createState() => _UploadNotesScreenState();
}

class _UploadNotesScreenState extends State<UploadNotesScreen> {
  File? _selectedFile;
  bool _uploading = false;

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Notes - ${widget.group}')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _selectedFile != null
                ? Text('Selected File: ${_selectedFile!.path}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                : Container(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _pickFile();
              },
              child: Text('Select File', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploading ? null : () => _uploadFile(),
              child: _uploading
                  ? CircularProgressIndicator()
                  : Text('Upload File', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilesListScreen(group: widget.group),
                  ),
                );
              },
              child: Text('View Uploaded Files', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
      print('File picked: ${_selectedFile!.path}');
    } else {
      print('No file selected');
    }
  }

  void _uploadFile() async {
    setState(() {
      _uploading = true;
    });

    try {
      if (_selectedFile != null) {
        File file = _selectedFile!;
        String fileName = file.path.split('/').last;

        // Upload file to Firebase Storage
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('notes/${widget.group}/$fileName');
        await storageRef.putFile(file);

        // Get download URL from storage
        String fileUrl = await storageRef.getDownloadURL();

        // Save file details to Firestore
        await FirebaseFirestore.instance.collection('notes').add({
          'group': widget.group,
          'fileName': fileName,
          'fileUrl': fileUrl,
          'timestamp': DateTime.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File uploaded successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('No file selected');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading file: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }
}

class FilesListScreen extends StatefulWidget {
  final String group;

  FilesListScreen({required this.group});

  @override
  _FilesListScreenState createState() => _FilesListScreenState();
}

class _FilesListScreenState extends State<FilesListScreen> {
  late Future<List<Map<String, dynamic>>> _filesFuture;

  @override
  void initState() {
    super.initState();
    _filesFuture = getFilesForGroup(widget.group);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Files - ${widget.group}')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _filesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No files available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> fileData = snapshot.data![index];
                return Card(
                  elevation: 3, // Add elevation for a shadow effect
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(fileData['fileName']),
                    trailing: IconButton(
                      icon: Icon(Icons.download), // Download icon
                      onPressed: () {
                        _launchURL(fileData['fileUrl']);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to launch URL in default browser
  void _launchURL(String url) async {
    // Encode the URL string to handle special characters
    // String encodedUrl = Uri.encodeFull(url);

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<List<Map<String, dynamic>>> getFilesForGroup(String group) async {
    List<Map<String, dynamic>> filesList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('notes')
        .where('group', isEqualTo: group)
        .get();

    querySnapshot.docs.forEach((doc) {
      if (doc.exists &&
          doc.data() != null &&
          doc.data()!.containsKey('fileName')) {
        Map<String, dynamic> fileData = {
          'fileName': doc['fileName'],
          'fileUrl': doc['fileUrl'],
        };
        filesList.add(fileData);
      } else {
        print('Document does not contain fileName field: ${doc.id}');
        // Handle the case where the fileName field is missing if needed
      }
    });

    return filesList;
  }
}
