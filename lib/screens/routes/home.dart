import 'dart:developer';

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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('petsInfo')
            .doc(user)
            .collection(widget.userModel.uEmail.toString())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          log('Snapshot Data: ${snapshot.data?.docs.length}');

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No pets found.",
                style: TextStyle(fontFamily: 'AppFont'),
              ),
            );
          }

          List<Pet> pets = snapshot.data!.docs.map((doc) {
            log('Document Data: ${doc.data()}');
            return Pet.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

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
