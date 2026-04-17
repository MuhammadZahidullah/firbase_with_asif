import 'package:firbase_with_asif/post/add_post_screen.dart';
import 'package:firbase_with_asif/ui/auth/login_screen.dart';
import 'package:firbase_with_asif/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final searchFilterController = TextEditingController();
  final editController = TextEditingController();
  final firebaseRef = FirebaseDatabase.instance.ref('post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('post Screen'),
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
            MaterialPageRoute(builder: (context) => AddPostScreen()),
          );
        },
        child: Icon(Icons.add),
      ),

      body: Column(
        children: [
          SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchFilterController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search',
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),

          Expanded(
            child: FirebaseAnimatedList(
              query: firebaseRef,
              defaultChild: Text('loading'),
              itemBuilder: (context, snapshot, animation, index) {
                // print(snapshot.value);

                final title = snapshot.child('title').value.toString();
                if (searchFilterController.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop;
                              showMyDiolog(
                                title,
                                snapshot.child('id').value.toString(),
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
                              firebaseRef
                                  .child(snapshot.child('id').value.toString())
                                  .remove();
                            },
                            leading: Icon(Icons.delete_forever_outlined),
                            title: Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (title.toLowerCase().contains(
                  searchFilterController.text.toLowerCase(),
                )) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                } else {
                  return Container();
                }
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
                firebaseRef
                    .child(id)
                    .update({'title': editController.text.toString()})
                    .then((value) {
                      Utilities().toastMessage('Post Updated');
                    })
                    .onError((error, StackTrace) {
                      Utilities().toastMessage(error.toString());
                    });
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

/*          Expanded(
            child: StreamBuilder(
              stream: firebaseRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  Map<dynamic, dynamic> map =
                      snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list = [];
                  list.clear();
                  list = map.values.toList();
                  return ListView.builder(
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(list[index]['title']),
                        subtitle: Text(list[index]['id']),
                      );
                    },
                  );
                }
              },
            ),
          ),*/
