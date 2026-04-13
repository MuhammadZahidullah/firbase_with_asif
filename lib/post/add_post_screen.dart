import 'package:firbase_with_asif/utils/utilities.dart';
import 'package:firbase_with_asif/widgets/rounded_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Post')),
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
                databaseRef
                    .child(DateTime.now().microsecondsSinceEpoch.toString())
                    .set({
                      'title': postController.text.toString(),
                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    })
                    .then((value) {
                      Utilities().toastMessage('Post Added');
                      setState(() {
                        loading = false;
                      });
                    })
                    .onError((error, StackTrace) {
                      Utilities().toastMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
