import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPat extends StatefulWidget {
  const AddPat({super.key});

  @override
  State<AddPat> createState() => _AddPatState();
}

class _AddPatState extends State<AddPat> {
  final _formKey = GlobalKey<FormState>();

  late User? user = FirebaseAuth.instance.currentUser;
  File? _img;
  final picker = ImagePicker();
  String imgUrl = '';
  String? id;
  Future getImage() async {
    final pickedImg = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImg != null) {
        _img = File(pickedImg.path);
      }
    });
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

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
                  onPressed: getImage,
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
                  controller: _heightController,
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
                      id = user!.email;
                      if (_img == null) {
                        print('No image selected');
                        return;
                      }
                      try {
                        Reference storageReference = FirebaseStorage.instance
                            .ref()
                            .child('users/username');

                        UploadTask uploadTask = storageReference.putFile(_img!);
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
                            'height': int.parse(_heightController.text),
                            'imageUrl': imgUrl,
                          };

                          saveImageUrlToDatabase(imgUrl, petData, id);

                          // _nameController.clear();
                          // _ageController.clear();
                          // _genderController.clear();
                          // _typeController.clear();
                          // _heightController.clear();
                          // setState(() {
                          //   _img = null;
                          // });
                        }
                      } catch (e) {
                        print('Error uploading image or adding data: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    child: const Text('Add to App'),
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

Future<void> saveImageUrlToDatabase(
    String imageUrl, Map<String, dynamic> petData, String? id) async {
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref('pets');

  await databaseReference.child(id!).set(petData);
}
