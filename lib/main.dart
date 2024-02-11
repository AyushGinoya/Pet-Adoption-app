import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/helper/get_user_model.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/screens/navigation%20bar/navigation_bar.dart';
import 'package:pet_adoption_app/screens/routes/register.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    //Logged in
    runApp(const MyApp());
  } else {
    UserModel? currentModel = await GetUserModel.getUserModelById(user.uid);
    if (currentModel != null) {
      runApp(MyAppLoggedIn(userModel: currentModel, firebaseUser: user));
    } else {
      runApp(const MyApp());
    }
  }
}

//not loggedIn
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Register(),
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavigationMenu(),
    );
  }
}
