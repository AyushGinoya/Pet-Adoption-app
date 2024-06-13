import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/screens/login/login.dart';
import 'package:pet_adoption_app/screens/settings/delete_account_policy.dart';
import 'package:pet_adoption_app/screens/settings/privacy_policy.dart';
import 'package:pet_adoption_app/screens/settings/update_profile.dart';
import 'package:pet_adoption_app/screens/settings/user_pets.dart';

class Profile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const Profile(
      {super.key, required this.userModel, required this.firebaseUser});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? imageFile;
  bool _isEditing = false;
  bool _isLoading = false;
  ValueNotifier<bool> isUploading = ValueNotifier<bool>(false);
  String? userName;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    userName = widget.userModel.uName.toString();
  }

  Widget buildButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    Color color = Colors.blue,
    Color textColor = Colors.black,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              color: Colors.lightBlue,
              child: Icon(icon, color: textColor),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(color: textColor, fontFamily: 'AppFont'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Upload Profile Picture"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Navigator.pop(context);
                selectImage(ImageSource.gallery);
              },
              leading: const Icon(Icons.photo_album),
              title: const Text("Select from Gallery"),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                selectImage(ImageSource.camera);
              },
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Photo"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateProfilePic(File imageFile) async {
    isUploading.value = true; // Start uploading
    try {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("ProfilePics")
          .child(widget.userModel.uName.toString())
          .putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask;
      String imgUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.firebaseUser.uid)
          .update({
        'profilePicture': imgUrl,
      });

      setState(() {});

      print("Profile picture updated successfully");
    } catch (e) {
      print("Failed to update profile picture: $e");
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    bool? confirmed; // Variable to hold the result of the confirmation dialog

    try {
      setState(() {
        _isLoading = true;
      });

      // Show confirmation dialog
      confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text(
                'Are you sure you want to delete your account? This action cannot be undone.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Dismiss the dialog with a cancel action
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  Navigator.of(context)
                      .pop(true); // Dismiss the dialog with a delete action
                },
              ),
            ],
          );
        },
      );

      if (!confirmed!) {
        // If the user cancels the dialog, exit early
        return;
      }

      String uid = widget.firebaseUser.uid;

      // Delete user's added pets
      QuerySnapshot petSnapshot = await FirebaseFirestore.instance
          .collection('petsInfo')
          .where('owner', isEqualTo: widget.userModel.uName)
          .get();

      for (QueryDocumentSnapshot doc in petSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete user data from Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      // Delete user from Firebase Authentication
      await widget.firebaseUser.delete();

      await FirebaseAuth.instance.signOut();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const Login();
      }));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete account: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        title: const Text(
          'Settings',
          style: TextStyle(fontFamily: 'AppFont', fontSize: 24),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        color: const Color(0xFFE6E6FA),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(200),
                      bottomRight: Radius.circular(200),
                    ),
                    child: Container(
                      height: 200,
                      width: 400,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(218, 216, 50, 0.9669117647058824),
                            Color.fromRGBO(107, 170, 120, 1),
                            Color.fromRGBO(201, 164, 177, 1),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Center(
                          child: ValueListenableBuilder<bool>(
                            valueListenable: isUploading,
                            builder: (context, isUploading, child) {
                              if (isUploading) {
                                return const CircularProgressIndicator();
                              } else {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(widget
                                              .userModel.uProfile
                                              .toString()),
                                          backgroundColor: Colors.white,
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 3,
                                          child: Center(
                                            child: Container(
                                              width: 30.0,
                                              height: 30.0,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue,
                                              ),
                                              child: Center(
                                                child: IconButton(
                                                  icon: const Icon(Icons.edit,
                                                      size: 16.0),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    showPhotoOptions();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      userName ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'AppFont',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      'Account',
                      style: TextStyle(
                        fontFamily: 'AppFont',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(height: 1),
                  const SizedBox(height: 4),
                  const SizedBox(height: 10),
                  buildButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateProfile(
                            firebaseUser: widget.firebaseUser,
                            userModel: widget.userModel,
                          ),
                        ),
                      );
                    },
                    icon: Icons.edit,
                    label: 'Edit Profile',
                  ),
                  const SizedBox(height: 10),
                  buildButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserPetsPage(
                            userModel: widget.userModel,
                            firebaseUser: widget.firebaseUser,
                          ),
                        ),
                      );
                    },
                    icon: Icons.upload_file_outlined,
                    label: 'Your Uploaded Pets',
                  ),
                  const SizedBox(height: 10),
                  buildButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const Login();
                      }));
                    },
                    icon: Icons.logout,
                    label: 'Logout',
                    color: Colors.green,
                    textColor: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Application',
                      style: TextStyle(
                        fontFamily: 'AppFont',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(height: 1),
                  const SizedBox(height: 4),
                  const SizedBox(height: 10),
                  buildButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicy(),
                        ),
                      );
                    },
                    icon: Icons.privacy_tip,
                    label: 'Privacy Policy',
                  ),
                  const SizedBox(height: 10),
                  buildButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeleteAccountPolicy(),
                        ),
                      );
                    },
                    icon: Icons.delete,
                    label: 'Delete Account Policy',
                  ),
                  const SizedBox(height: 10),
                  buildButton(
                    onPressed: () {
                      deleteAccount(context);
                    },
                    icon: Icons.delete_forever_sharp,
                    label: 'Delete Account',
                    color: Colors.red,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
