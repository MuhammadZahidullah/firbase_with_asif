import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreTestPage extends StatelessWidget {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  FirestoreTestPage({super.key});

  void addData() async {
    await db.collection('test').add({'name': 'Zahid', 'time': DateTime.now()});
    print('Data added');
  }

  void readData() async {
    var snapshot = await db.collection('test').get();
    for (var doc in snapshot.docs) {
      print(doc.data());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firestore Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: addData, child: Text('Add Data')),
            ElevatedButton(onPressed: readData, child: Text('Read Data')),
          ],
        ),
      ),
    );
  }
}
