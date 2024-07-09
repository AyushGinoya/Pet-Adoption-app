import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
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
  String? user;
  String _selectedGender = 'Male';

  final database = FirebaseFirestore.instance.collection("petsInfo");
  late File? _img;
  String imgUrl = '';
  late bool _isLoading = false;

  @override
  void initState() {
    _img = null;
    super.initState();
    user = widget.userModel.uName.toString();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _subTypeController = TextEditingController();

  Future<void> selectImage(ImageSource source) async {
    final XFile? selectedImage = await ImagePicker().pickImage(source: source);

    if (selectedImage != null) {
      final CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: selectedImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
      );

      if (croppedImage != null) {
        setState(() {
          _img = File(croppedImage.path);
        });
        log("Image selected and cropped!");
      } else {
        log("Image cropping canceled");
      }
    } else {
      log("Image not selected");
    }
  }

  void showPhotoOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Image Source"),
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
            ),
          ],
        ),
      ),
    );
  }

  bool checkValues() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Name is Empty")));
      return false;
    }

    if (_ageController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Age is empty')));
      return false;
    } else if (double.tryParse(_ageController.text) == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('age must be a number')));
      return false;
    } else if (double.parse(_ageController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('age must be greater than 0')));
      return false;
    }

    if (_typeController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Type is empty')));
      return false;
    }

    if (_subTypeController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Sub Type is empty')));
      return false;
    }

    if (_heightController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Height is empty"')));
      return false;
    } else if (double.tryParse(_heightController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Height must be a number')));
      return false;
    } else if (double.parse(_heightController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Height must be greater than 0')));
      return false;
    }

    if (_img == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Image is not selected')));
      return false;
    }
    return true;
  }

  Future<void> addPet() async {
    if (!checkValues()) {
      log('Please fill all the fields and select an image');
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('petsImages')
          .child(user!)
          .child(const Uuid().v1())
          .putFile(_img!);

      TaskSnapshot snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        imgUrl = await snapshot.ref.getDownloadURL();
      }

      Map<String, dynamic> petData = {
        'name': _nameController.text,
        'age': int.parse(_ageController.text),
        'gender': _selectedGender,
        'type': _typeController.text,
        'subType': _subTypeController.text,
        'height': int.parse(_heightController.text),
        'imageUrl': imgUrl,
        'owner': user,
      };

      await database.add(petData);

      _nameController.clear();
      _ageController.clear();
      _typeController.clear();
      _heightController.clear();
      _subTypeController.clear();
      setState(() {
        _img = null;
        _isLoading = false;
      });
    } catch (e) {
      log('Error uploading image or adding data: $e');
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
          'Add Pet',
          style: TextStyle(fontFamily: 'AppFont', fontSize: 24),
        ),
        centerTitle: true,
        titleSpacing: 2.0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFE6E6FA),
          padding: const EdgeInsets.only(
            top: 16,
            left: 15,
            right: 15,
          ),
          child: Column(
            children: [
              const Text(
                'All fields is Mandatory',
                style: TextStyle(
                    color: Colors.red, fontFamily: 'AppFont', fontSize: 24),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: GestureDetector(
                  onTap: showPhotoOptions,
                  child: Container(
                    height: 300,
                    width: 340,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 209, 207, 207),
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
                              SizedBox(height: 10),
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
              Container(
                color: Colors.white,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.white,
                child: TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const ListTile(
                title: Text('Gender'),
              ),
              Container(
                color: Colors.white,
                child: RadioListTile<String>(
                  title: const Text('Male'),
                  value: 'Male',
                  activeColor: const Color.fromARGB(255, 141, 73, 129),
                  groupValue: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
              ),
              Container(
                color: Colors.white,
                child: RadioListTile<String>(
                  title: const Text('Female'),
                  value: 'Female',
                  activeColor: const Color.fromARGB(255, 141, 73, 129),
                  groupValue: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.white,
                child: TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                    hintText: 'Enter type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.white,
                child: TextFormField(
                  controller: _subTypeController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Sub type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.white,
                child: TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter height(in cm)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: addPet,
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
                      : const Text('Add pet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
