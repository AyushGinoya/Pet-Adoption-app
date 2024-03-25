// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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
    Key? key,
    required this.targetUser,
    required this.chatroom,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

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
    try {
      paymentIntentData = await createPaymentIntent('11111', 'USD');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            customFlow: true,
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            style: ThemeMode.light,
            merchantDisplayName: 'Ayush',
            allowsDelayedPaymentMethods: true,
            googlePay: const PaymentSheetGooglePay(
                merchantCountryCode: "US", testEnv: true)),
      );

      displayPaymentSheet();
    } catch (e) {
      print("exception:" + e.toString());
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        // 'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization':
              'Bearer sk_test_51Oy5H4SJzZrzkNTA73vB8wF1OQ3IV595Ee3OpxnXIZyimBr7DxZk7uQaEQFzK5izRqmlJNDnAc3iUHbmeb7OzeMI00g8DL28pP',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );

      if (response.statusCode == 200) {
        //print('Create Intent response ===> ${response.body.toString()}');
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create payment intent');
      }
    } catch (e) {
      print("exception:$e");
      throw e; // Rethrow the exception to handle it in the calling method
    }
  }

  // displayPaymentSheet() async {
  //   try {
  //     // Assuming paymentIntentData is correctly set up and contains the 'client_secret'
  //     await Stripe.instance.presentPaymentSheet().then((newValue) {
  //       print('Payment result: $newValue done');
  //       if (newValue == true) {
  //         // Assuming 'true' indicates a successful payment
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text("Payment successful")));
  //       } else {
  //         ScaffoldMessenger.of(context)
  //             .showSnackBar(const SnackBar(content: Text("Payment failed")));
  //       }
  //     }).onError((error, stackTrace) {
  //       print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
  //     });
  //   } on StripeException catch (e) {
  //     print('Exception/DISPLAYPAYMENTSHEET==> $e');
  //     showDialog(
  //         context: context,
  //         builder: (_) => const AlertDialog(
  //               content: Text("Payment failed"),
  //             ));
  //   } catch (e) {
  //     print('$e');
  //   }
  // }

  displayPaymentSheet() async {
    // try {
    //   await Stripe.instance.presentPaymentSheet();
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(const SnackBar(content: Text("Payment successful")));
    // } catch (e) {
    //   print('Exp. - $e');
    // }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 224, 84),
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
                            MessageModel currentMessage = MessageModel.fromMap(
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(
                                    color: currentMessage.sender ==
                                            widget.userModel.uName
                                        ? Colors.blue[200]
                                        : const Color.fromARGB(
                                            255, 100, 97, 97),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    currentMessage.text.toString(),
                                    style: const TextStyle(color: Colors.white),
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
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Enter message"),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await makePayment();
                    },
                    child: const Text('Pay'),
                  ),
                  IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send,
                        color: Color.fromARGB(255, 240, 224, 84)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
