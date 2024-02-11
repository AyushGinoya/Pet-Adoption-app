import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 224, 84),
        appBar: AppBar(
          title: const Text("Search"),
        ),
        body: SafeArea(
            child: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
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
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 140,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Search',
                        style: TextStyle(color: Colors.black))),
              ),
              const SizedBox(
                height: 30,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("uName", isEqualTo: name.text.trim())
                      .where("uName", isNotEqualTo: widget.userModel.uName)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot querySnapshot =
                            snapshot.data as QuerySnapshot;

                        if (querySnapshot.docs.isNotEmpty) {
                          Map<String, dynamic> userMap = querySnapshot.docs[0]
                              .data() as Map<String, dynamic>;

                          UserModel searchModel = UserModel.fromMap(userMap);

                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ChatRoomPage()));
                              },
                              leading: CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 240, 224, 84),
                                backgroundImage:
                                    NetworkImage(searchModel.uProfile!),
                              ),
                              title: Text(searchModel.uName!),
                              subtitle: Text(searchModel.uEmail!),
                              trailing: const Icon(Icons.keyboard_arrow_right),
                            ),
                          );
                        } else {
                          return const Text("No results found");
                        }
                      } else if (snapshot.hasError) {
                        return const Text("An error occurred");
                      } else {
                        return const Text("No data");
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ],
          ),
        )));
  }
}
