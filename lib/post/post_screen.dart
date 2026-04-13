import 'package:firbase_with_asif/post/add_post_screen.dart';
import 'package:firbase_with_asif/ui/auth/login_screen.dart';
import 'package:firbase_with_asif/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final firebaseRef = FirebaseDatabase.instance.ref('post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('post Screen'),

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
            MaterialPageRoute(builder: (context) => AddPostScreen()),
          );
        },
        child: Icon(Icons.add),
      ),

      body: Column(
        children: [
          FirebaseAnimatedList(
            query: firebaseRef,
            defaultChild: Text('loading'),
            itemBuilder: (context, snapshot, animation, index) {
              return ListTile(
                title: Text(snapshot.child('title').value.toString()),
                subtitle: Text(snapshot.child('id').value.toString()),
              );
            },
          ),
        ],
      ),
    );
  }
}
