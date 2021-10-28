import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homework_3/components/snackbar.dart';
import 'package:homework_3/models/user.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  final String uid;

  FirebaseService({this.uid = ''});

  Future<UserCredential?> createEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ('Password is too weak');
      } else if (e.code == 'email-already-in-use') {
        throw ('This email is already in use');
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  Future<UserCredential?> loginEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw ('Wrong password provided for that user.');
      }
    }
  }

  Future<UserCredential> signInAnon() async {
    return await _auth.signInAnonymously();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocument(String uid) {
    return _firestore.collection('users').doc(uid).get();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> currentUserStream() {
    return _auth.authStateChanges();
  }

  Stream<User?> userChangesStream() {
    return _auth.userChanges();
  }

  User? currentUser() {
    return _auth.currentUser;
  }

  Stream<QuerySnapshot> get users {
    return _userCollection.snapshots();
  }

  Future<void> userLogout(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text('YES'),
              onPressed: () async {
                try {
                  await _auth.signOut();
                  snackbar(context, 'User successfully logged out.', 5);
                  Navigator.of(context).pop();
                } catch (error) {
                  throw ErrorDescription(error.toString());
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addUserDocument(context, String fName, String lName, String age,
      String bio, String fullName) async {
    await _userCollection
        .doc(_auth.currentUser?.uid)
        .set({
          'fName': fName,
          'lName': lName,
          'age': age,
          'bio': bio,
          'creationDate': DateTime.now(),
          'id': _auth.currentUser?.uid,
          'fullName': fullName
        })
        .then((value) => snackbar(context, "User Added", 5))
        .catchError((error) => throw (error));
  }

  Stream<List<Users>> streamUsers() {
    Stream<List<Users>> list = _firestore
        .collection('users')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> list) => list.docs
            .map((DocumentSnapshot<Map<String, dynamic>> snap) =>
                Users.fromMap(snap.data() as Map<String, dynamic>))
            .toList())
        .handleError((dynamic e) {
      print(e);
    });
    return list;
  }
}
