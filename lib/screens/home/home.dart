// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/helper/get_chatroom_model.dart';
import 'package:pet_adoption_app/helper/get_user_model.dart';
import 'package:pet_adoption_app/models/chat_room_model.dart';
import 'package:pet_adoption_app/models/pet_model.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/helper/custom_card_layout.dart';
import 'package:pet_adoption_app/screens/chat/chat_room.dart';

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

  bool _onWillPop(BuildContext context) {
    bool? exitResult = showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    ) as bool?;
    return exitResult ?? false;
  }

  Future<bool?> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Do you want to exit the app?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => exit(0),
          child: const Text('Yes'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2196F3),
        title: const Text(
          '🐶Home😸',
          style: TextStyle(fontFamily: 'AppFont', fontSize: 24),
        ),
        centerTitle: true,
        titleSpacing: 2.0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFE6E6FA),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('petsInfo').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Waiting for data...');
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print('No data or empty snapshot');
            print('Snapshot data: ${snapshot.data}');
            return const Center(
              child: Text(
                "No pets found.",
                style: TextStyle(fontFamily: 'AppFont'),
              ),
            );
          }

          print('Data fetched successfully');
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Pet pet = Pet.fromMap(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);
              return InkWell(
                onTap: () async {
                  String? ownerName = pet.owner;
                  // print(ownerUid);
                  UserModel? ownerUserModel =
                      await GetUserModel.getUserModelByName(ownerName!);
                  ChatRoomModel? chatRoomModel =
                      await GetChatRoom.getChatRoomModel(
                          ownerUserModel!, widget.userModel);

                  if (chatRoomModel != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomPage(
                          targetUser: ownerUserModel,
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser,
                          chatroom: chatRoomModel,
                        ),
                      ),
                    );
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomCart().cartWidget(pet: pet),
                    Positioned(
                      bottom: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Text(
                          'Connect',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
