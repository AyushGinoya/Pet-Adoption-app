import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_adoption_app/models/user_model.dart';

class GetUserModel {
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;

    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (documentSnapshot.data() != null) {
      userModel =
          UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }

    return userModel;
  }

  static Future<UserModel?> getUserModelByName(String uName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("uName", isEqualTo: uName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      return UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }
    return null;
  }
}
