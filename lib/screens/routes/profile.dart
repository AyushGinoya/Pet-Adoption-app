// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_adoption_app/models/user_model.dart';

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
  ValueNotifier<bool> isUploading = ValueNotifier<bool>(false);

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.userModel.uAddress ?? '';
    _usernameController.text = widget.userModel.uName ?? '';
    _phoneController.text = widget.userModel.uNumber ?? '';
    _emailController.text = widget.userModel.uEmail ?? '';
  }

  void _saveUserInfo() async {
    String uid = widget.firebaseUser.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      'uAddress': _addressController.text,
      'uName': _usernameController.text,
      'uNumber': _phoneController.text,
      'uEmail': _emailController.text,
    });

    setState(() {
      _isEditing = false;
    });
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
            ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontFamily: 'AppFont', fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.transparent, // Make AppBar background transparent

      body: Container(
        width: double.infinity, // Ensure the container fills the screen width
        height: double.infinity, // Ensure the container fills the screen height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 240, 224, 84), // Original yellow
              Color.fromARGB(255, 240, 200, 50), // Slightly darker yellow
              Color.fromARGB(255, 245, 233, 77), // Lighter yellow
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: showPhotoOptions,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: isUploading,
                        builder: (context, isUploading, child) {
                          if (isUploading) {
                            return const CircularProgressIndicator();
                          } else {
                            return CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  widget.userModel.uProfile.toString()),
                              backgroundColor: Colors.white,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Username',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      enabled: _isEditing,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      enabled: _isEditing,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.mail_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      enabled: _isEditing,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Address',
                        prefixIcon: const Icon(Icons.location_city),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      enabled: _isEditing,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_isEditing)
                      ElevatedButton(
                        onPressed: _saveUserInfo,
                        child: const Text('Save'),
                      ),
                    ElevatedButton(
                      onPressed: _toggleEdit,
                      child: Text(_isEditing ? 'Cancel' : 'Edit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
