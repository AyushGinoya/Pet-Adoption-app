// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/screens/navigation_bar.dart';
import 'package:pet_adoption_app/screens/Register/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;

  void loginUser() async {
    UserCredential? userCredential;
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid email address")));
      return;
    }

    if (password.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password must be at least 6 characters long")));
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userData.exists) {
        UserModel userModel =
            UserModel.fromMap(userData.data() as Map<String, dynamic>);

        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => NavigationMenu(
                  userModel: userModel, firebaseUser: userCredential!.user!)),
        );
        setState(() {
          loading = false;
        });
      } else {
        print("User document does not exist.");
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? "Login Failed")));
      Navigator.pop(context);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.2,
                left: 35,
              ),
              child: const Text(
                "Login to your account,",
                style: TextStyle(fontFamily: 'AppFont', fontSize: 33),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.15,
                left: 35,
                right: 35,
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'email',
                      prefixIcon: const Icon(Icons.mail_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'password',
                      prefixIcon: const Icon(Icons.lock_open),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 140,
                    child: ElevatedButton(
                      onPressed: loading ? null : loginUser,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: 'AppFont',
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()));
                    },
                    child: const Text(
                      'Register here',
                      style: TextStyle(
                          fontFamily: 'AppFont',
                          color: Colors.black,
                          fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
