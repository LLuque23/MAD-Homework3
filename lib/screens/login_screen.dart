import 'package:flutter/material.dart';
import 'package:homework_3/services/firebase_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          FirebaseService().signInAnon();
        },
        child: const Text('Login Anon'),
      ),
    );
  }
}
