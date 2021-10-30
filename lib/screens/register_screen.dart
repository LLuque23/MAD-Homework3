import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:homework_3/components/snackbar.dart';
import 'package:homework_3/constants/constants.dart';
import 'package:homework_3/services/firebase_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fName = '';
  String lName = '';
  String age = '';
  String bio = '';
  bool isloading = false;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return isloading
        ? const Center(
            child: CircularProgressIndicator(
              backgroundColor: kAppColor,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Register'),
            ),
            body: Form(
              key: _formkey,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (!EmailValidator.validate(value!)) {
                            return "Please enter Password";
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Email',
                          prefixIcon: const Icon(
                            FontAwesomeIcons.mailBulk,
                            color: kAppColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Password";
                          }
                        },
                        onChanged: (value) {
                          password = value;
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Password',
                          prefixIcon: const Icon(
                            FontAwesomeIcons.userLock,
                            color: kAppColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          fName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter First Name";
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'First Name',
                          prefixIcon: const Icon(
                            FontAwesomeIcons.user,
                            color: kAppColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          lName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Last Name";
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Last Name',
                          prefixIcon: const Icon(
                            FontAwesomeIcons.user,
                            color: kAppColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          age = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Age";
                          }
                          if (num.tryParse(value) == null) {
                            return "Please enter valid Age";
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Age',
                          prefixIcon: const Icon(
                            FontAwesomeIcons.hashtag,
                            color: kAppColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          bio = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Bio";
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Bio',
                          prefixIcon: const Icon(
                            FontAwesomeIcons.info,
                            color: kAppColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                isloading = true;
                              });
                              try {
                                UserCredential? user = await _firebaseService
                                    .createEmailAndPassword(email, password);
                                if (user != null) {
                                  await _firebaseService.addUserDocument(
                                      context,
                                      fName,
                                      lName,
                                      age,
                                      bio,
                                      fName + " " + lName);
                                }
                                Navigator.of(context).pop();
                              } catch (e) {
                                snackbar(context, e.toString(), 3);
                              }
                            }
                          },
                          child: const Text("Create Account"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
