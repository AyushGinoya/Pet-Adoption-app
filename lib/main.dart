import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/helper/get_user_model.dart';
import 'package:pet_adoption_app/helper/stripe_keys.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/screens/navigation_bar.dart';
import 'package:pet_adoption_app/screens/routes/login.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

var uuid = const Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = StripeKeys.publishableKey;
  await Stripe.instance.applySettings();
  //await FirebaseAppCheck.instance.activate();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCgOxtS5rgQExGpjCV4NeYmqfL08ZgM1vA',
        authDomain: 'pet-adoption-app-a630e.firebaseapp.com',
        projectId: 'pet-adoption-app-a630e',
        appId: '1:220029605349:android:37a9d08e718b1508b3cb0c',
        messagingSenderId: '220029605349',
        storageBucket: "gs://pet-adoption-app-a630e.appspot.com",
      ),
    );
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(MySplashApp());
}

//not loggedIn
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const MyAppLoggedIn(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavigationMenu(
        userModel: userModel,
        firebaseUser: firebaseUser,
      ),
    );
  }
}

class MySplashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), checkAuthentication);
  }

  void checkAuthentication() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const MyApp()));
    } else {
      UserModel? userModel = await GetUserModel.getUserModelById(user.uid);
      if (userModel != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) =>
                MyAppLoggedIn(userModel: userModel, firebaseUser: user)));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => const MyApp()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash_screen.png',
              fit: BoxFit.fitHeight,
            ),
            // const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
