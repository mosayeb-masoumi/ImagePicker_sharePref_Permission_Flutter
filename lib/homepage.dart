


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_sharepref_flutter/constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'dart:io';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  /// Variables
  // late File imageFile = File("");
  // File imageFile;
  var imageFile = null;

  // var imageFile;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _counter = pref.getInt(Constant.pref_counter) ?? 0;
    });
  }

  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt(Constant.pref_counter) ?? 0) + 1;
    });

    prefs.setInt(Constant.pref_counter, _counter);
  }

  @override
  Widget build(BuildContext context) => Scaffold(

        body: Container(

          child: Center(
            // child: Container(
            child: Container(

              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  FlatButton(
                    child: Text(
                      "click",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      _incrementCounter();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        "$_counter",
                        // startNumber.toString(),
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    child: Text(
                      "check and request camera perrmission",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed: () async {
                      if (await Permission.camera.request().isGranted) {
                        // Either the permission was already granted before or the user just granted it.
                        print("Camera Permission is granted");
                      } else {
                        print("Camera Permission is denied.");
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    child: Text(
                      "check and request camera location permission",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed: () async {
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.location,
                        Permission.camera,
                        //add more permission to request here.
                      ].request();

                      if (statuses[Permission.location]!.isDenied) {
                        //check each permission status after.
                        print("Location permission is denied.");
                      }

                      if (statuses[Permission.camera]!.isDenied) {
                        //check each permission status after.
                        print("Camera permission is denied.");
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    child: Text(
                      "PICK FROM GALLERY",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      _getFromGallery();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    child: Text(
                      "PICK FROM CAMERA",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      _getFromCamera();
                    },
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  imageFile != (null)?
                  Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                  ): Container(

                    color: Colors.grey,
                    height: 400,
                    width: 100,
                    child: const Align(
                      alignment: Alignment.center,
                        child: Text("No data")
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
