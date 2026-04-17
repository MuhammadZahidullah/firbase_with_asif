import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase_with_asif/utils/utilities.dart';
import 'package:firbase_with_asif/widgets/rounded_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Addfirestorescreen extends StatefulWidget {
  const Addfirestorescreen({super.key});

  @override
  State<Addfirestorescreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<Addfirestorescreen> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('post');
  final fireStore = FirebaseFirestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add firestore data')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 30),
            TextFormField(
              controller: postController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'What is in your mind',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),

            RoundedButton(
              title: 'Add Post',

              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().microsecondsSinceEpoch.toString();
                fireStore
                    .doc(id)
                    .set({'title': postController.text.toString(), 'id': id})
                    .then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utilities().toastMessage('Post Added');
                    })
                    .onError((error, StackTrace) {
                      setState(() {
                        loading = false;
                      });
                      Utilities().toastMessage(error.toString());
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
