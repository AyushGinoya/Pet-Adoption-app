import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_adoption_app/helper/sing_up_controller.dart';
import 'package:pet_adoption_app/screens/routes/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  final databaseRef = FirebaseDatabase.instance.ref('users');

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SingUpController());
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
                            controller: controller.usernameController,
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
                            controller: controller.emailController,
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
                            controller: controller.passwordController,
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
                            controller: controller.numberController,
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
                            controller: controller.addressController,
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
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            await controller.registerUsers(
                              controller.emailController.text.trim(),
                              controller.passwordController.text.trim(),
                              controller.usernameController.text.trim(),
                              controller.numberController.text.trim(),
                              controller.addressController.text.trim(),
                              controller.passwordController.text.trim(),
                            );

                            setState(() {
                              loading = false;
                            });

                            loading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    "Sign in",
                                    style: TextStyle(
                                        fontFamily: 'AppFont',
                                        color: Colors.black),
                                  );
                          }
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
                                "Sign in",
                                style: TextStyle(
                                    fontFamily: 'AppFont', color: Colors.black),
                              )),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
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
