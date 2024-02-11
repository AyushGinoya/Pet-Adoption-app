import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pet_adoption_app/helper/get_user_model.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/screens/routes/addpat.dart';
import 'package:pet_adoption_app/screens/routes/chats.dart';
import 'package:pet_adoption_app/screens/routes/home.dart';
import 'package:pet_adoption_app/screens/routes/profile.dart';
import 'package:flutter/material.dart';

class NavigationIconController extends GetxController {
  final Rx<int> selectIndex = 0.obs;
  UserModel? userModel1;
  RxList<Widget> screens = RxList<Widget>([]);

  @override
  void onInit() {
    super.onInit();
    fetchUserModelAndSetupScreens();
  }

  void fetchUserModelAndSetupScreens() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      UserModel? um = await GetUserModel.getUserModelById(user.uid);
      if (um != null) {
        userModel1 = um;
        screens.value = [
          Home(userModel: userModel1!, firebaseUser: user),
          const AddPat(),
          Chats(userModel: userModel1!, firebaseUser: user),
          const Profile(),
        ];
      } else {
        print("Model is Null");
      }
      update(); // Notify listeners about changes
    }
  }
}
