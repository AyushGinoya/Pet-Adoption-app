// ignore_for_file: avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/helper/custom_card_layout.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:pet_adoption_app/models/user_model.dart';

class Home extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const Home({super.key, required this.userModel, required this.firebaseUser});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String user;
  Pet? petModel;

  @override
  void initState() {
    super.initState();
    user = widget.userModel.uName.toString();
  }

  Stream<List<Pet>> getPetsStream() async* {
    List<Pet> pets = [];
    try {
      QuerySnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance.collection("petsInfo").get();
      print('Fetched docSnapshot: ${docSnapshot.docs.length}');

      // for (var userDoc in userSnapshot.docs) {
      //   String username = userDoc.id;
      //   QuerySnapshot emailSnapshot =
      //       await userDoc.reference.collection(username).get();
      //   print(
      //       'Fetched emailSnapshot for $username: ${emailSnapshot.docs.length}');

      //   for (var emailDoc in emailSnapshot.docs) {
      //     String pet = emailDoc.id;
      //     QuerySnapshot petsSnap =
      //         await emailDoc.reference.collection(pet).get();
      //     print('Fetched petsSnap for $pet: ${petsSnap.docs.length}');

      //     for (var petDoc in petsSnap.docs) {
      //       pets.add(Pet.fromMap(petDoc.data() as Map<String, dynamic>));
      //     }
      //   }
      // }
    } catch (e) {
      print('Error fetching pets: $e');
    }
    yield pets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🐶Home😸',
          style: TextStyle(fontFamily: 'AppFont', fontSize: 30),
        ),
        centerTitle: true,
        titleSpacing: 2.0,
      ),
      backgroundColor: const Color.fromARGB(255, 240, 224, 84),
      body: StreamBuilder<List<Pet>>(
        stream: getPetsStream(),
        builder: (context, AsyncSnapshot<List<Pet>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No pets found.",
                style: TextStyle(fontFamily: 'AppFont'),
              ),
            );
          }

          List<Pet> pets = snapshot.data ?? [];

          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (BuildContext context, int index) {
              return CustomCart().cartWidget(
                pet: pets[index],
                user: user,
              );
            },
          );
        },
      ),
    );
  }
}
