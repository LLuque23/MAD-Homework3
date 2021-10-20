import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homework_3/screens/home_screen.dart';
import 'package:homework_3/screens/landing_screen.dart';
import 'package:homework_3/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Midterm App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: LandingScreen(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => const LoginScreen(),
        // '/register': (BuildContext context) => const RegisterScreen(),
        '/home': (BuildContext context) => const HomeScreen(),
      },
    );
  }
}