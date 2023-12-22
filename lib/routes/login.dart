import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: 35,
                  right: 35),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
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
