import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/pet_model.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/helper/custom_card_layout.dart';

class Home extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const Home({super.key, required this.userModel, required this.firebaseUser});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String user;

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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pets').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No pets found.",
                style: TextStyle(fontFamily: 'AppFont'),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Pet pet = Pet.fromMap(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);
              return CustomCart()
                  .cartWidget(pet: pet); // Corrected usage
            },
          );
        },
      ),
    );
  }
}
