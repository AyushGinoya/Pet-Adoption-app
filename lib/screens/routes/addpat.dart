import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:uuid/uuid.dart';

class AddPat extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const AddPat(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<AddPat> createState() => _AddPatState();
}

class _AddPatState extends State<AddPat> {
  final _formKey = GlobalKey<FormState>();

  String? id;

  String _selectedGender = 'Male';

  final database = FirebaseFirestore.instance.collection("petsInfo");
  late File? _img;
  String imgUrl = '';
  late bool _isLoading = false;

  @override
  void initState() {
    _img = null;
    super.initState();
    id = widget.userModel.uName;
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _subTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.1,
            left: 15,
            right: 15,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: GestureDetector(
                    onTap: () async {
                      // Updated to include image picking logic
                      XFile? selectedImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (selectedImage != null) {
                        setState(() {
                          _img = File(selectedImage
                              .path); // Make sure to declare `imageFile` of type `File?` at class level
                        });
                        log("Image selected!");
                      } else {
                        log("Image not selected");
                      }
                    },
                    child: Container(
                      height: 300,
                      width: 340, // Adjusted height
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 209, 207, 207),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: _img != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: Image.file(
                                _img!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 300,
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                                SizedBox(
                                    height: 10), // Space between icon and text
                                Text(
                                  "Tap to select an image",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const ListTile(
                  title: Text('Gender'),
                ),
                RadioListTile<String>(
                  title: const Text('Male'),
                  value: 'Male',
                  activeColor: const Color.fromARGB(255, 240, 224, 84),
                  groupValue: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Female'),
                  value: 'Female',
                  activeColor: const Color.fromARGB(255, 240, 224, 84),
                  groupValue: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _typeController,
                  decoration: InputDecoration(
                    hintText: 'Enter type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter type";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _subTypeController,
                  decoration: InputDecoration(
                      hintText: 'Enter Sub type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter sub type";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter height(in cm)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter height';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_img == null) {
                        log('No image selected');
                        return;
                      }
                      try {
                        setState(() {
                          _isLoading = true;
                        });
                        UploadTask uploadTask = FirebaseStorage.instance
                            .ref()
                            .child('patesImages')
                            .child(id!)
                            .child(const Uuid().v1())
                            .putFile(_img!);

                        TaskSnapshot snapshot = await uploadTask;

                        if (snapshot.state == TaskState.success) {
                          imgUrl = await snapshot.ref.getDownloadURL();
                        }

                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> petData = {
                            'name': _nameController.text,
                            'age': int.parse(_ageController.text),
                            'gender': _selectedGender,
                            'type': _typeController.text,
                            'subType': _subTypeController.text,
                            'height': int.parse(_heightController.text),
                            'imageUrl': imgUrl,
                          };

                          await database
                              .doc(id)
                              .collection(widget.userModel.uEmail.toString())
                              .doc(const Uuid().v4())
                              .set(petData);

                          _nameController.clear();
                          _ageController.clear();
                          _genderController.clear();
                          _typeController.clear();
                          _heightController.clear();
                          _subTypeController.clear();
                          setState(() {
                            _img = null;
                            _isLoading = false;
                          });
                        }
                      } catch (e) {
                        log('Error uploading image or adding data: $e');
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          )
                        : const Text('Add to App'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
