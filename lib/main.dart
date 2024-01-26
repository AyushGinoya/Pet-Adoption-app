import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pet_adoption_app/screens/navigation%20bar/addpat.dart';
import 'package:pet_adoption_app/screens/navigation%20bar/cart.dart';
import 'package:pet_adoption_app/screens/navigation%20bar/home.dart';
import 'package:pet_adoption_app/screens/navigation%20bar/navigation_bar.dart';
import 'package:pet_adoption_app/screens/navigation%20bar/profile.dart';
import 'package:pet_adoption_app/screens/routes/login.dart';
import 'package:pet_adoption_app/screens/routes/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCgOxtS5rgQExGpjCV4NeYmqfL08ZgM1vA',
      authDomain: 'pet-adoption-app-a630e.firebaseapp.com',
      projectId: 'pet-adoption-app-a630e',
      appId: '1:220029605349:android:37a9d08e718b1508b3cb0c',
      messagingSenderId: '220029605349',
      storageBucket: "gs://pet-adoption-app-a630e.appspot.com",
      databaseURL: "https://pet-adoption-app-a630e-default-rtdb.firebaseio.com",
    ),
  );
  runApp(GetMaterialApp(
    home: const Text('Pet-Adoption-App'),
    debugShowCheckedModeBanner: false,
    initialRoute: 'navigation',
    routes: {
      'register': (context) => const Register(),
      'login': (context) => const Login(),
      'home': (context) => const Home(),
      'navigation': (context) => const NavigationMenu(),
      'addpat': (context) => const AddPat(),
      'profile': (context) => const Profile(),
      'cart': (context) => const Cart(),
    },
  ));
}
