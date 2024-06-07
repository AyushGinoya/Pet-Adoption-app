import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/helper/get_chatroom_model.dart';
import 'package:pet_adoption_app/models/chat_room_model.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/screens/routes/chat_room.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User user;

  const SearchPage({super.key, required this.userModel, required this.user});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 224, 84),
        appBar: AppBar(
          title: const Text("Search"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: const Icon(Icons.person_outlined),
                    hintText: 'User Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 140,
                child: ElevatedButton(
                  onPressed: () => setState(() {}),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Search',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("uName", isEqualTo: name.text.trim())
                      .where("uName", isNotEqualTo: widget.userModel.uName)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Text("An error occurred");
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return const Text("No results found");
                      }
                      QuerySnapshot querySnapshot = snapshot.data!;
                      Map<String, dynamic> userMap = querySnapshot.docs.first
                          .data() as Map<String, dynamic>;
                      UserModel searchModel = UserModel.fromMap(userMap);

                      return ListTile(
                        onTap: () async {
                          ChatRoomModel? chatRoomModel =
                              await GetChatRoom.getChatRoomModel(
                                  searchModel, widget.userModel);
                          if (chatRoomModel != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatRoomPage(
                                          targetUser: searchModel,
                                          userModel: widget.userModel,
                                          firebaseUser: widget.user,
                                          chatroom: chatRoomModel,
                                        )));
                          }
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(searchModel.uProfile ?? ''),
                        ),
                        title: Text(searchModel.uName ?? ''),
                        subtitle: Text(searchModel.uEmail ?? ''),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      );
                    } else {
                      return const Text("No data");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
