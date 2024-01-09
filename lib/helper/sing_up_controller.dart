import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_adoption_app/firebase/firebase_auth.dart';
import 'package:pet_adoption_app/screens/navigation%20bar/navigation_bar.dart';

class SingUpController extends GetxController {
  static SingUpController get instance => Get.find();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<void> registerUser(String email, String password) async {
    FirebaseAuthentication.instance
        .createUserWithEmailandPassword(email, password);
  }

  Future<void> registerUsers(String email, String password, String username,
      String mobile, String address, String pass) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Set the display name
        await user.updateDisplayName(username);
      }

      if (userCredential.user != null) {
        DatabaseReference databaseRef = FirebaseDatabase.instance.ref('users');

        //await user.updateDisplayName(username);

        await databaseRef.child(username).set({
          'username': username,
          'email': email,
          'mobile': mobile,
          'address': address,
          'password': pass,
        });

        await Get.to(() => const NavigationMenu());
      } else {
        //print('User registration failed: userCredential is null');
      }
    } catch (e) {
      //print('Error creating user: $e');
    }
  }
}
