import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  Users(
      {required this.fName,
      required this.lName,
      required this.age,
      required this.creationDate,
      required this.bio,
      required this.id,
      required this.fullName,
      required this.ratings});

  final String fName;
  final String lName;
  final String age;
  final String bio;
  final Timestamp creationDate;
  final String id;
  final String fullName;
  final List ratings;

  factory Users.fromMap(Map<String, dynamic> data) {
    return Users(
        fName: data['fName'],
        lName: data['lName'],
        age: data['age'],
        bio: data['bio'],
        creationDate: data['creationDate'],
        id: data['id'],
        fullName: data['fullName'],
        ratings: data['ratings']);
  }
}
