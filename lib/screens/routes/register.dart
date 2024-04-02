import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/screens/routes/complete_register.dart';
import 'package:pet_adoption_app/screens/routes/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();
  late EmailAuth auth;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    auth = EmailAuth(sessionName: 'session');
  }

  void checkValue(BuildContext context) async {
    String userName = usernameController.text.trim();
    String email = emailController.text.trim();
    String pass = passwordController.text.trim();
    String cPass = cPasswordController.text.trim();

    if (userName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username cannot be empty")));
      setState(() {
        loading = false;
      });
    }

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter a valid email")));
      setState(() {
        loading = false;
      });
    }
    sendOTP();

    if (pass.isEmpty || pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password must be at least 6 characters long")));
      setState(() {
        loading = false;
      });
    }

    if (pass != cPass) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")));
      setState(() {
        loading = false;
      });
    }
    showOTPDialog(context);
  }

  void signUp(String email, String pass, String uName) async {
    UserCredential? credential;

    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      log(e.code.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;

      UserModel newUser = UserModel(
          uName: uName,
          uPassword: pass,
          uEmail: email,
          uAddress: "",
          uNumber: "",
          uProfile: "");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) => log("new user created"));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompleteRegister(
            firebaseUser: credential!.user!,
            userModel: newUser,
          ),
        ),
      );

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> sendOTP() async {
    try {
      bool result = await auth.sendOtp(
          recipientMail: emailController.value.text, otpLength: 5);
      if (result) {
        // Optionally update the UI or notify the user that the OTP was sent
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP sent to ${emailController.value.text}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send OTP")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending OTP: $e")),
      );
    }
  }

  void showOTPDialog(BuildContext context) {
    TextEditingController otpController = TextEditingController();

    Future<void> verify() async {
      try {
        bool result = auth.validateOtp(
            recipientMail: emailController.value.text,
            userOtp: otpController.value.text);
        if (result) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP Verified")),
          );
          String userName = usernameController.text.trim();
          String email = emailController.text.trim();
          String pass = passwordController.text.trim();

          signUp(email, pass, userName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Incorrect OTP")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error verifying OTP: $e")),
        );
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close dialog
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter OTP'),
          content: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'OTP',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                verify();
              },
              child: const Text('Verify'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(), // Dismiss the dialog
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 224, 84),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1, left: 30),
            child: const Text(
              "Sign Up to Find Your Perfect Pet,",
              style: TextStyle(fontFamily: 'AppFont', fontSize: 28),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.3,
                right: 35,
                left: 35),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'username',
                        prefixIcon: const Icon(Icons.person_2_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: const Icon(Icons.mail_outline),
                        hintText: 'email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'password',
                        prefixIcon: const Icon(Icons.lock_open),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: cPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'conform password',
                        prefixIcon: const Icon(Icons.lock_open),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 160,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          loading = !loading;
                        });
                        checkValue(context);
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(color: Colors.black)),
                      child: loading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            )
                          : const Text(
                              "Complete Profile",
                              style: TextStyle(
                                  fontFamily: 'AppFont',
                                  fontSize: 12,
                                  color: Colors.black),
                            ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: const Text(
                      'Already logged in? Click here',
                      style: TextStyle(
                          fontFamily: 'AppFont',
                          color: Colors.black,
                          fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
