import 'dart:io';

import 'package:api_wala_app/image_selector.dart';
import 'package:api_wala_app/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String newImagePath;
  List<String> files = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () {
              gsi.GoogleSignIn().signOut();
              files.clear();
              setState(() {});
            },
            child: Text('Sign Out'),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (newImagePath == null)
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    String pickedImagePath =
                        await ImageSelector().clickkImageAndGetImagePath();
                    setState(() {
                      newImagePath = pickedImagePath;
                    });
                  },
                  icon: Icon(Icons.camera),
                  label: Text('Click Image'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    String pickedImagePath =
                        await ImageSelector().pickkImageAndGetImagePath();
                    setState(() {
                      newImagePath = pickedImagePath;
                    });
                  },
                  icon: Icon(Icons.image),
                  label: Text('Pick Image'),
                )
              ],
            ),
          if (newImagePath != null)
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  newImagePath = null;
                });
              },
              child: Text('Clear Image'),
            ),
          SizedBox(
            height: 40,
          ),
          Container(
            height: 500,
            width: 300,
            padding: EdgeInsets.all(5),
            color: newImagePath != null ? Colors.green[100] : Colors.white,
            child: newImagePath != null
                ? Image.file(
                    File(newImagePath),
                    fit: BoxFit.cover,
                  )
                : Container(
                    child: FutureBuilder<List<String>>(
                        future: DriveUtilities().listGoogleDriveFiles(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            print('Loading....');
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          files = snapshot.data;
                          print(snapshot.data);
                          return ListView.builder(
                            itemCount: files.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(files[index]),
                              );
                            },
                          );
                        }),
                  ),
          ),
          if (newImagePath != null)
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await DriveUtilities().uploadImage(newImagePath, []);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Uploaded'),
                    ),
                  );
                } catch (err) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Not Uploaded'),
                    ),
                  );
                }
              },
              icon: Icon(Icons.upload_file),
              label: Text('Upload Image'),
            )
        ],
      ),
    );
  }
}
