import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firbase_with_asif/post/add_post_screen.dart';
import 'package:firbase_with_asif/ui/auth/login_screen.dart';
import 'package:firbase_with_asif/ui/firestore/add_firestore_screen.dart';
import 'package:firbase_with_asif/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/ui/firebase_animated_list.dart';
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
  final fireStore = FirebaseFirestore.instance.collection('Users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('Users');
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

          StreamBuilder<QuerySnapshot>(
            stream: fireStore,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return CircularProgressIndicator();

                  if (snapshot.hasError) return Text('Some Error');

                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {},
                          title: Text(
                            snapshot.data!.docs[index]['title'].toString(),
                          ),
                          subtitle: Text(snapshot.data!.docs[index].id),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    showMyDiolog(
                                      snapshot.data!.docs[index]['title']
                                          .toString(),
                                      snapshot.data!.docs[index]['id']
                                          .toString(),
                                    );
                                  },
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit'),
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    ref
                                        .doc(
                                          snapshot.data!.docs[index]['id']
                                              .toString(),
                                        )
                                        .delete();
                                  },
                                  leading: Icon(Icons.delete_forever_outlined),
                                  title: Text('Delete'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
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
                ref
                    .doc(id)
                    .update({'title': editController.text})
                    .then((value) {
                      Utilities().toastMessage('Updated');
                    })
                    .onError((error, StackTrace) {
                      Utilities().toastMessage(error.toString());
                    });
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .doc(id)
                    .update({'title': editController.text})
                    .then((value) {
                      Utilities().toastMessage('Updated');
                    })
                    .onError((error, stackTrace) {
                      Utilities().toastMessage(error.toString());
                    });
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
