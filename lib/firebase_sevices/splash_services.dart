import 'dart:async';

import 'package:firbase_with_asif/post/post_screen.dart';
import 'package:firbase_with_asif/ui/auth/login_screen.dart';
import 'package:firbase_with_asif/ui/firestore/firestore_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FirestoreListScreen()),
        );
      });
    } else {
      Timer(Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    }
  }
}
