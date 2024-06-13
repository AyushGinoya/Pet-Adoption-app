import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/user_model.dart';

class UpdateProfile extends StatefulWidget {
  final User firebaseUser;
  final UserModel userModel;
  const UpdateProfile(
      {super.key, required this.firebaseUser, required this.userModel});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  bool _isEditing = false;

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

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.userModel.uAddress ?? '';
    _usernameController.text = widget.userModel.uName ?? '';
    _phoneController.text = widget.userModel.uNumber ?? '';
    _emailController.text = widget.userModel.uEmail ?? '';
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontFamily: 'AppFont', fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFE6E6FA),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Username',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  enabled: _isEditing,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  enabled: _isEditing,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.mail_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  enabled: _isEditing,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Address',
                    prefixIcon: const Icon(Icons.location_city),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  enabled: _isEditing,
                ),
                const SizedBox(height: 20),
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
        ),
      ),
    );
  }
}
