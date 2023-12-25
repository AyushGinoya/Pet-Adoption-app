import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/routes/home.dart';
import 'package:pet_adoption_app/routes/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _numberController.dispose();
    _addressController.dispose();
    super.dispose();
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
              // "Sign Up to Make \nNew Friends,",
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
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'username',
                                prefixIcon: const Icon(Icons.person_2_outlined),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Username";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: const Icon(Icons.mail_outline),
                                hintText: 'email',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Email";
                              }
                              return null;
                            },
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
                                    borderRadius: BorderRadius.circular(12))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Password";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _numberController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'mobile number',
                                prefixIcon: const Icon(Icons.phone_rounded),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter mobile number";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _addressController,
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Address',
                                prefixIcon:
                                    const Icon(Icons.my_location_rounded),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Address";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      )),
                  SizedBox(
                    width: 140,
                    child: OutlinedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            _auth.createUserWithEmailAndPassword(
                                email: _emailController.text.toString(),
                                password: _passwordController.text.toString());

                                Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                          }
                        },
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            side: const BorderSide(color: Colors.black)),
                        child: loading
                            ? CircularProgressIndicator()
                            : const Text(
                                "Sign in",
                                style: TextStyle(
                                    fontFamily: 'AppFont', color: Colors.black),
                              )),
                  ),
                  const SizedBox(
                    height: 20,
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
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
