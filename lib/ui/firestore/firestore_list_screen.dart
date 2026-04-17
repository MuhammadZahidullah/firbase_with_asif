import 'package:firbase_with_asif/post/add_post_screen.dart';
import 'package:firbase_with_asif/ui/auth/login_screen.dart';
import 'package:firbase_with_asif/ui/firestore/add_firestore_screen.dart';
import 'package:firbase_with_asif/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({super.key});

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  final auth = FirebaseAuth.instance;
  //final searchFilterController = TextEditingController();
  final editController = TextEditingController();
  //final firebaseRef = FirebaseDatabase.instance.ref('post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FireStore'),
        centerTitle: true,
        automaticallyImplyLeading: false,

        actions: [
          IconButton(
            onPressed: () {
              auth
                  .signOut()
                  .then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  })
                  .onError((error, StackTrace) {
                    Utilities().toastMessage(error.toString());
                  });
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Addfirestorescreen()),
          );
        },
        child: Icon(Icons.add),
      ),

      body: Column(
        children: [
          SizedBox(height: 15),

          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(title: Text('Muhammad Zahidullah'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showMyDiolog(String title, String id) async {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(hintText: 'Edite Here'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
