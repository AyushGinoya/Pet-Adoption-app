import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pet_adoption_app/screens/navigation%20bar/navigation_bar.dart';

class LoginController {
  static LoginController get instance => Get.find();
  Future<void> login(String email, String pass) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass);

    if (userCredential.user != null) {
      await Get.to(() => const NavigationMenu());
    }
  }
}
