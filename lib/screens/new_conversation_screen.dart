import 'package:flutter/material.dart';
import 'package:homework_3/models/user.dart';

class NewConversationScreen extends StatelessWidget {
  const NewConversationScreen(
      {Key? key,
      required this.uid,
      required this.contact,
      required this.convoID})
      : super(key: key);

  final String uid;
  final Users contact;
  final String convoID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("uid:" + uid),
            Text("contact:" + contact.toString()),
            Text("convoID:" + convoID),
          ],
        ),
      ),
    );
  }
}
