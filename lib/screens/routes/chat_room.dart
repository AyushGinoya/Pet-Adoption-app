import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 224, 84),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(child: Container()),
              Container(
                color: Colors.grey[200],
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    const Flexible(
                        child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Enter msg"),
                    )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.send,
                          color: const Color.fromARGB(255, 240, 224, 84),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
