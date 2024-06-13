import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pet_adoption_app/helper/get_user_model.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/screens/add/addpat.dart';
import 'package:pet_adoption_app/screens/chat/chats.dart';
import 'package:pet_adoption_app/screens/home/home.dart';
import 'package:pet_adoption_app/screens/settings/profile.dart';
import 'package:flutter/material.dart';

class NavigationIconController extends GetxController {
  final Rx<int> selectIndex = 0.obs;
  UserModel? userModel1;
  RxList<Widget> screens = RxList<Widget>([]);
 

  var currentScreen = 'home'.obs; // Current screen name
  var isNavigationBarVisible = true.obs; // Add this property

  void updateCurrentScreen(String screenName) {
    currentScreen.value = screenName;
  }


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
          AddPat(userModel: userModel1!, firebaseUser: user),
          Chats(userModel: userModel1!, firebaseUser: user),
          Profile(userModel: userModel1!, firebaseUser: user),
        ];
      } else {
        log('Model is Null');
      }
      // Notify listeners about changes
      update();
    }
  }
}
