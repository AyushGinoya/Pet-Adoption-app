import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/screens/routes/search_page.dart';

class Chats extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const Chats({super.key, required this.userModel, required this.firebaseUser});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adoption Inquiry'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 240, 224, 84),
      ),
      body: const Center(child: Text('My Chats')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchPage(
                      userModel: widget.userModel, user: widget.firebaseUser)));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
