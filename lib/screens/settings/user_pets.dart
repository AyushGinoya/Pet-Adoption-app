import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/pet_model.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/helper/custom_card_layout.dart';

class UserPetsPage extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const UserPetsPage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Pets',
          style: TextStyle(fontFamily: 'AppFont', fontSize: 30),
        ),
        centerTitle: true,
        titleSpacing: 2.0,
      ),
      backgroundColor: const Color(0xFFE6E6FA),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('petsInfo').snapshots(),
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

          // Filter pets owned by the current user
          List<DocumentSnapshot> userPets = snapshot.data!.docs.where((doc) {
            return (doc.data() as Map<String, dynamic>)['owner'] ==
                userModel.uName;
          }).toList();

          if (userPets.isEmpty) {
            return const Center(
              child: Text(
                "You don't have any pets.",
                style: TextStyle(fontFamily: 'AppFont'),
              ),
            );
          }

          return ListView.builder(
            itemCount: userPets.length,
            itemBuilder: (BuildContext context, int index) {
              Pet pet =
                  Pet.fromMap(userPets[index].data() as Map<String, dynamic>);
              return Stack(
                alignment: Alignment.center,
                children: [
                  CustomCart().cartWidget(
                    pet: pet,
                    // currentUser: userModel.uName.toString(),
                    // onDelete: () {
                    //   FirebaseFirestore.instance
                    //       .collection('petsInfo')
                    //       .doc(userPets[index].id)
                    //       .delete();
                    // },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
