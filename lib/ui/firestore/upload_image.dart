import 'dart:io';

import 'package:firbase_with_asif/utils/utilities.dart';
import 'package:firbase_with_asif/widgets/rounded_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  bool loading = false;
  File? image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference dataBaseRef = FirebaseDatabase.instance.ref('post');

  Future imagePicker() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Images'),
        centerTitle: true,
        shadowColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  imagePicker();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black87),
                  ),
                  child: image != null
                      ? Image.file(image!, fit: BoxFit.cover)
                      : Icon(Icons.browse_gallery_sharp),
                ),
              ),
            ),
            SizedBox(height: 30),
            RoundedButton(
              title: 'Upload Image',
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage
                    .instance
                    .ref(
                      '/foldername/'
                      'DateTime.now().microsecondsSinceEpoch',
                    );
                firebase_storage.UploadTask uploadTask = ref.putFile(
                  image!.absolute,
                );

                Future.value(uploadTask)
                    .then((value) async {
                      var newUrl = await ref.getDownloadURL();
                      dataBaseRef
                          .child('1')
                          .set({'id': '1212', 'title': newUrl.toString()})
                          .then((value) {
                            setState(() {
                              loading = false;
                            });
                            Utilities().toastMessage('uploaded');
                          })
                          .onError((error, StackTrace) {
                            setState(() {
                              loading = false;
                            });
                          });
                    })
                    .onError((e, StackTrace) {
                      Utilities().toastMessage(e.toString());
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
