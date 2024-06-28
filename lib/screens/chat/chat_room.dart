// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pet_adoption_app/helper/stripe_keys.dart';
import 'package:pet_adoption_app/main.dart';
import 'package:pet_adoption_app/models/chat_room_model.dart';
import 'package:pet_adoption_app/models/message_model.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:http/http.dart' as http;

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;
  const ChatRoomPage({
    super.key,
    required this.targetUser,
    required this.chatroom,
    required this.userModel,
    required this.firebaseUser,
  });
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  Map<String, dynamic>? paymentIntentData;
  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();
    if (msg.isNotEmpty) {
      MessageModel newMessage = MessageModel(
        createdOn: DateTime.now(),
        seen: false,
        sender: widget.userModel.uName,
        text: msg,
        messageid: uuid.v1(),
      );
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatRoomID)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());
      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatRoomID)
          .set(widget.chatroom.toMap());
      log("Message sent");
    }
  }

  Future<void> makePayment() async {
    final TextEditingController _amountController = TextEditingController();
    // Show dialog to enter payment amount
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter payment amount'),
        content: TextField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(hintText: "Amount in INR"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                var amountInPaisa =
                    (double.parse(_amountController.text)).toInt().toString();
                paymentIntentData =
                    await createPaymentIntent(amountInPaisa, 'INR');
                await Stripe.instance.initPaymentSheet(
                  paymentSheetParameters: SetupPaymentSheetParameters(
                    customFlow: true,
                    paymentIntentClientSecret:
                        paymentIntentData!['client_secret'],
                    style: ThemeMode.light,
                    merchantDisplayName: 'Pets Adoption',
                    allowsDelayedPaymentMethods: true,
                    googlePay: const PaymentSheetGooglePay(
                        merchantCountryCode: "IN", testEnv: true),
                  ),
                );
                displayPaymentSheet();
              } catch (e) {
                print("exception: $e");
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer ${StripeKeys.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      if (response.statusCode == 200) {
        //print('Create Intent response ===> ${response.body.toString()}');
        Map<String, dynamic> paymentData = json.decode(response.body);
        await storePaymentData(paymentData);
        return paymentData;
      } else {
        throw Exception('Failed to create payment intent');
      }
    } catch (e) {
      print("exception:$e");
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  Future<void> storePaymentData(Map<String, dynamic> paymentData) async {
    try {
      Map<String, dynamic> mainInfo = {
        'username': widget.userModel.uName.toString(),
        'status': paymentData['status'],
        'amount': paymentData['amount'],
        'currency': paymentData['currency'],
        'id': paymentData['id'],
        'payment_method_types': paymentData['payment_method_types'],
      };
      await FirebaseFirestore.instance.collection('payments').add(mainInfo);
      print('Payment data stored successfully');
    } catch (e) {
      print('Failed to store payment data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF2196F3),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage:
                    NetworkImage(widget.targetUser.uProfile.toString()),
              ),
              const SizedBox(width: 15),
              Text(widget.targetUser.uName.toString()),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(widget.chatroom.chatRoomID)
                        .collection("messages")
                        .orderBy("createdOn", descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage =
                                  MessageModel.fromMap(
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>,
                              );
                              return Row(
                                mainAxisAlignment: currentMessage.sender ==
                                        widget.userModel.uName
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        right: 10, top: 4, bottom: 4, left: 4),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                      color: currentMessage.sender ==
                                              widget.userModel.uName
                                          ? Colors.blue[200]
                                          : const Color.fromARGB(
                                              255, 201, 199, 199),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 28,
                                          child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.white,
                                            backgroundImage:
                                                currentMessage.sender ==
                                                        widget.userModel.uName
                                                    ? NetworkImage(widget
                                                        .userModel.uProfile
                                                        .toString())
                                                    : NetworkImage(widget
                                                        .targetUser.uProfile
                                                        .toString()),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          currentMessage.text.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                                "Error occurred, please check your internet connection."),
                          );
                        } else {
                          return const Center(
                            child: Text("Say hi to the owner of the pet."),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: TextButton(
                        onPressed: () async {
                          await makePayment();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue, // Changing button color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                        ),
                        child: const Text(
                          'Pay',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Message",
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 25),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        child: Center(
                          child: IconButton(
                            onPressed: sendMessage,
                            icon: const Icon(
                              Icons.send,
                              color: Colors.blue, // Icon color
                            ),
                          ),
                        ),
                      ),
                    ),
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
