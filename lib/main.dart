import 'package:flutter/material.dart';
import 'package:pet_adoption_app/routes/register.dart';

void main() {
  runApp(MaterialApp(
    home: const Text('Pet-Adoption-App'),
    debugShowCheckedModeBanner: false,
    initialRoute: 'register',
    routes: {
      'register': (context) => const Register(),
    },
  ));
}
