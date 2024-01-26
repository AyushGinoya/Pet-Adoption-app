import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/helper/custom_card_layout.dart';
import 'package:pet_adoption_app/helper/pet.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String user = "ayush";
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
        stream: FirebaseDatabase.instance.ref('petsInfo').onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Pet> pets = [];
          DataSnapshot dataSnapshot = snapshot.data!.snapshot;
          if (dataSnapshot.exists) {
            for (var petKeySnapshot in dataSnapshot.children) {
              for (var petSubKeySnapshot in petKeySnapshot.children) {
                Map<String, dynamic> petData =
                    Map<String, dynamic>.from(petSubKeySnapshot.value as Map);
                pets.add(Pet.fromJson(petData));
              }
            }
          }

          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (BuildContext context, int index) {
              return CustomCart().cartWidget(
                pets[index].name,
                pets[index].age,
                pets[index].height,
                pets[index].gender,
                pets[index].imageUrl,
                user,
              );
            },
          );
        },
      ),
    );
  }
}
