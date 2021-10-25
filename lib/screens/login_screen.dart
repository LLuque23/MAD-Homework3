import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:homework_3/components/snackbar.dart';
import 'package:homework_3/constants/constants.dart';
import 'package:homework_3/services/firebase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
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
            body: Form(
              key: _formkey,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 50,
                            color: kAppColor,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 80),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Email";
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                isloading = true;
                              });
                              try {
                                await _firebaseService.loginEmailAndPassword(
                                    email, password);
                                snackbar(
                                    context, 'User Successfully signed in', 3);
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  snackbar(context,
                                      'No user with that email found', 3);
                                } else if (e.code == 'wrong-password') {
                                  snackbar(
                                      context,
                                      'Wrong password provided for that user.',
                                      3);
                                }
                              } catch (e) {
                                snackbar(context, e.toString(), 3);
                              }
                              setState(() {
                                isloading = false;
                              });
                            }
                          },
                          child: const Text("Sign In"),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Dont have an account? '),
                          GestureDetector(
                            child: const Text(
                              'Register Now',
                              style: TextStyle(
                                color: kAppColor,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed('/register');
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
