import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/routes/home.dart';
import 'package:pet_adoption_app/routes/login.dart';
import 'package:pet_adoption_app/routes/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      // Populate with your Firebase project configuration details
      apiKey: 'AIzaSyCgOxtS5rgQExGpjCV4NeYmqfL08ZgM1vA',
      authDomain: 'pet-adoption-app-a630e.firebaseapp.com',
      projectId: 'pet-adoption-app-a630e',
      appId: '1:220029605349:android:37a9d08e718b1508b3cb0c',
      messagingSenderId: '220029605349',
    ),
  );
  runApp(MaterialApp(
    home: const Text('Pet-Adoption-App'),
    debugShowCheckedModeBanner: false,
    initialRoute: 'register',
    routes: {
      'register': (context) => const Register(),
      'login': (context) => const Login(),
      'home' :(context) => const Home(),
    },
  ));
}
