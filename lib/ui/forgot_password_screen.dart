import 'package:firbase_with_asif/utils/utilities.dart';
import 'package:firbase_with_asif/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        centerTitle: true,
        shadowColor: Colors.black12,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(hintText: 'Enter Your Email'),
          ),
          SizedBox(height: 20),
          RoundedButton(
            title: 'reset password',
            onTap: () {
              auth
                  .sendPasswordResetEmail(
                    email: emailController.text.toString(),
                  )
                  .then((value) {
                    Utilities().toastMessage(
                      'We have sent Email, please check it ',
                    );
                  })
                  .onError((error, StackTrace) {
                    Utilities().toastMessage(error.toString());
                  });
            },
          ),
        ],
      ),
    );
  }
}
