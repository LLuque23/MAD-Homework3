import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homework_3/components/user_row.dart';
import 'package:homework_3/models/user.dart';
import 'package:homework_3/services/firebase_service.dart';
import 'package:provider/provider.dart';

class NewMessageProvider extends StatelessWidget {
  const NewMessageProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Users>>.value(
      value: FirebaseService().streamUsers(),
      initialData: const [],
      child: const NewMessageScreen(),
    );
  }
}

class NewMessageScreen extends StatelessWidget {
  const NewMessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseService().currentUser();
    final List<Users> userDirectory = Provider.of<List<Users>>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact'),
      ),
      body: userDirectory.isNotEmpty
          ? ListView(
              shrinkWrap: true,
              children: getListViewItems(userDirectory, user),
            )
          : const Text('Blabla'),
    );
  }
}

List<Widget> getListViewItems(List<Users> userDirectory, User? user) {
  final List<Widget> list = [];
  for (Users contact in userDirectory) {
    if (contact.id != user!.uid) {
      list.add(UserRow(uid: user.uid, contact: contact));
      list.add(const Divider(thickness: 1.0));
    }
  }
  return list;
}
