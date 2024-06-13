import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/screens/navigation_bar.dart';

class CompleteRegister extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const CompleteRegister(
      {super.key, required this.firebaseUser, required this.userModel});

  @override
  State<CompleteRegister> createState() => _CompleteRegisterState();
}

class _CompleteRegisterState extends State<CompleteRegister> {
  bool loading = false;

  final TextEditingController numberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? imageFile;

  _CompleteRegisterState();

  @override
  void dispose() {
    numberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void checkValues() {
    String? number = numberController.text.trim();
    String? address = addressController.text.trim();

    setState(() {
      loading = true;
    });

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Address cannot be empty")));
      setState(() {
        loading = false;
      });
      return;
    }

    if (number.isEmpty || number.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter a valid phone number")));
      setState(() {
        loading = false;
      });
      return;
    }

    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a profile image")));
      setState(() {
        loading = false;
      });
      return;
    }
    uploadData(number, address);
  }

  void uploadData(String number, String address) async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("ProfilePics")
        .child(widget.userModel.uName.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String imgUrl = await snapshot.ref.getDownloadURL();

    widget.userModel.uNumber = number;
    widget.userModel.uAddress = address;
    widget.userModel.uProfile = imgUrl;

    String uid = widget.firebaseUser.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(widget.userModel.toMap())
        .then((value) => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => NavigationMenu(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser)),
            ));
  }

  void selectImage(ImageSource imageSource) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile pickedFile) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
    );
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE6E6FA),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: showPhotoOptions,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        (imageFile != null) ? FileImage(imageFile!) : null,
                    child: (imageFile == null)
                        ? const Icon(Icons.add_a_photo, size: 60)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: addressController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: const Icon(Icons.location_on),
                    hintText: 'Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: numberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: const Icon(Icons.phone),
                    hintText: 'Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    checkValues();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign Up'),
                ),
              ],
            )));
  }
}
