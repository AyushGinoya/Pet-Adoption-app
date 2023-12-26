import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pet_adoption_app/routes/home.dart';
import 'package:pet_adoption_app/routes/register.dart';
class FirebaseAuthentication extends GetxController {
   static FirebaseAuthentication get instance => FirebaseAuthentication();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const Register());
    } else {
      Get.offAll(() => const Home());
    }
  }

  Future<UserCredential?> createUserWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      print("Error creating user: $e");
      return null;
    }
  }

  // Other methods in your FirebaseAuthentication class
}
