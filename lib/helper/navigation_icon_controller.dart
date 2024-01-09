import 'package:get/get.dart';
import 'package:pet_adoption_app/screens/navigation%20bar/addpat.dart';
import 'package:pet_adoption_app/screens/navigation%20bar/cart.dart';
import 'package:pet_adoption_app/screens/navigation%20bar/home.dart';
import 'package:pet_adoption_app/screens/navigation%20bar/profile.dart';

class NavigationIconController extends GetxController {
  final Rx<int> selectIndex = 0.obs;

  final screens = const [Home(), AddPat(), Cart(), Profile()];
}
