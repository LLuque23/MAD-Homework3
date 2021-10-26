import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:homework_3/constants/constants.dart';
import 'package:homework_3/services/firebase_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseService().getUserDocument(_user!.uid),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("User Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      FirebaseService().userLogout(context);
                    },
                    icon: const Icon(
                      FontAwesomeIcons.signOutAlt,
                    ),
                    tooltip: 'LOGOUT',
                  ),
                  Text(
                    data['fName'] + " " + data['lName'],
                    style: const TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/messageProvider'),
                    icon: const Icon(FontAwesomeIcons.plus, size: 30),
                  )
                ],
              ),
            ),
            body: const Center(
              child: Text('Home Screen'),
            ),
          );
        }

        return const CircularProgressIndicator(
          color: kAppColor,
        );
      },
    );
  }
}
