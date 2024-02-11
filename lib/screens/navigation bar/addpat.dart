import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class AddPat extends StatefulWidget {
  const AddPat({super.key});

  @override
  State<AddPat> createState() => _AddPatState();
}

class _AddPatState extends State<AddPat> {
  final _formKey = GlobalKey<FormState>();

  String? id = "ayush";
  late User? user = FirebaseAuth.instance.currentUser;
  final database = FirebaseDatabase.instance.ref('petsInfo');
  late File? _img;
  String imgUrl = '';
  late bool _isLoading = false;

  @override
  void initState() {
    _img = null;
    super.initState();
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  color: Colors.blueGrey,
                  child: _img != null
                      ? Image.file(
                          _img!,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    XFile? selectedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

                    if (selectedImage != null) {
                      File picFile = File(selectedImage.path);
                      setState(() {
                        _img = picFile;
                      });
                      log("Image selected!");
                    } else {
                      log("Image not selected");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  child: const Icon(Icons.add),
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
                TextFormField(
                  controller: _genderController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Enter Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Gender";
                    }
                    return null;
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
                      if (user == null) {
                        id = 'ayush';
                      } else {
                        id = user!.displayName;
                      }
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
                            'gender': _genderController.text,
                            'type': _typeController.text,
                            'subType': _subTypeController.text,
                            'height': int.parse(_heightController.text),
                            'imageUrl': imgUrl,
                          };

                          await database
                              .child(id!)
                              .child(const Uuid().v4())
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
