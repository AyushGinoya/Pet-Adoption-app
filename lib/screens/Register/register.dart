import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/screens/Register/complete_register.dart';
import 'package:pet_adoption_app/screens/Register/verify_otp.dart';
import 'package:pet_adoption_app/screens/login/login.dart';

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
  EmailOTP myAuth = EmailOTP();

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> checkValue(BuildContext context) async {
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
      return;
    }

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter a valid email")));
      setState(() {
        loading = false;
      });
      return;
    }

    if (pass.isEmpty || pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password must be at least 6 characters long")));
      setState(() {
        loading = false;
      });
      return;
    }

    if (pass != cPass) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")));
      setState(() {
        loading = false;
      });
      return;
    }

    myAuth.setConfig(
      appEmail: "petadoptionapp@gmail.com",
      appName: "Pet Adoption App",
      userEmail: email,
      otpLength: 6,
      otpType: OTPType.digitsOnly,
    );

    bool otpSent = await myAuth.sendOTP();
    if (otpSent) {
      print('OTP sent');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP sent")),
      );
      signUp(email, pass, userName);
    } else {
      print('Failed to send OTP');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send OTP")),
      );
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> signUp(String email, String pass, String uName) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);

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
          .set(newUser.toMap());

      print("New user created");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyVerify(
            firebaseUser: credential.user!,
            userModel: newUser,
            email: email,
            myAuth: myAuth,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      //log(e.code.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Error during registration")),
      );
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA),
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
                        hintText: 'confirm password',
                        prefixIcon: const Icon(Icons.lock_open),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 160,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
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
                          builder: (context) => const Login(),
                        ),
                      );
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
