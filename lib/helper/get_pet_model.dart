import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_adoption_app/models/pet_model.dart';

class GetPetModel {
  static Future<Pet?> getPetModelById(String petId) async {
    Pet? petModel;

    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("pets").doc(petId).get();

    if (documentSnapshot.data() != null) {
      petModel = Pet.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }

    return petModel;
  }
}
