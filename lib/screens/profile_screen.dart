import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('users').doc(_uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("ERROR"),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            List<dynamic> ratings = snapshot.data['ratings'];
            ratings.map((e) => int.parse(e));
            num total = 0;
            for (var element in ratings) {
              total += int.parse(element);
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(snapshot.data['fullName']),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "BIO",
                          style: TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.underline),
                        ),
                        Text(
                          ': ' + snapshot.data['bio'],
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'CONVERSATION RATING',
                          style: TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.underline),
                        ),
                        Text(
                          ': ' +
                              (total == 0
                                  ? 'No ratings yet'
                                  : (total / ratings.length).toString()),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
