import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_adoption_app/firebase/firebase_auth.dart';
import 'package:pet_adoption_app/routes/home.dart';

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
      String mobile, String address) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        DatabaseReference databaseRef = FirebaseDatabase.instance.ref('users');

        await databaseRef.child(userCredential.user!.uid).set({
          'username': username,
          'email': email,
          'mobile': mobile,
          'address': address,
        });

        await Get.to(() => const Home());
      } else {
        print('User registration failed: userCredential is null');
      }
    } catch (e) {
      print('Error creating user: $e');
      // Handle registration failure - Display an error message, prompt user to try again, etc.
    }
  }
}
