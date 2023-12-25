import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 224, 84),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2, left: 35),
              child: const Text(
                "Login to your account,",
                style: TextStyle(fontFamily: 'AppFont', fontSize: 33),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.8,
                  left: 35,
                  right: 35),
              child: Column(
                children: [
                  Form(
                      key: _formKey,
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
                                    borderRadius: BorderRadius.circular(12))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Email";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _passwordController,
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
                        ],
                      )),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 140,
                    child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            side: const BorderSide(color: Colors.black)),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              fontFamily: 'AppFont', color: Colors.black),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        'forget password',
                        style: TextStyle(
                            fontFamily: 'AppFont',
                            color: Colors.black,
                            fontSize: 15),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
