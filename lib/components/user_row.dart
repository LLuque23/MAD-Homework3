import 'package:flutter/material.dart';
import 'package:homework_3/constants/helper_functions.dart';
import 'package:homework_3/models/user.dart';
import 'package:homework_3/screens/new_conversation_screen.dart';

class UserRow extends StatelessWidget {
  const UserRow({Key? key, required this.uid, required this.contact})
      : super(key: key);
  final String uid;
  final Users contact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => createConversation(context),
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            contact.fullName,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void createConversation(BuildContext context) {
    String convoID = HelperFunctions().getConvoID(uid, contact.id);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            NewConversationScreen(uid: uid, contact: contact, convoID: convoID),
      ),
    );
  }
}
