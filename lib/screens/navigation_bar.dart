import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_adoption_app/helper/navigation_icon_controller.dart';
import 'package:pet_adoption_app/models/user_model.dart';

class NavigationMenu extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const NavigationMenu(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  Future<bool> _showExitConfirmationDialog() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationIconController());
    return WillPopScope(
      onWillPop: () async {
        if (controller.selectIndex.value == 0) {
          // If already on the Home screen, ask user if they want to exit
          return await _showExitConfirmationDialog();
        } else {
          // If not on Home, navigate to Home
          controller.selectIndex.value = 0;
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 223, 30, 30),
        bottomNavigationBar: Obx(
          () => Container(
            color: const Color.fromARGB(255, 223, 30,
                30), // Background color for the bottom navigation bar
            child: BottomNavigationBar(
              currentIndex: controller.selectIndex.value,
              onTap: (index) {
                controller.selectIndex.value = index;
              },
              items: [
                _buildBottomNavigationBarItem(
                  icon: Icons.home,
                  label: 'Home',
                  isSelected: controller.selectIndex.value == 0,
                ),
                _buildBottomNavigationBarItem(
                  icon: Icons.add_box,
                  label: 'Add',
                  isSelected: controller.selectIndex.value == 1,
                ),
                _buildBottomNavigationBarItem(
                  icon: Icons.chat,
                  label: 'Chats',
                  isSelected: controller.selectIndex.value == 2,
                ),
                _buildBottomNavigationBarItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  isSelected: controller.selectIndex.value == 3,
                ),
              ],
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              backgroundColor: const Color.fromARGB(255, 223, 30, 30),
            ),
          ),
        ),
        body: Obx(() => controller.screens.isNotEmpty
            ? controller.screens[controller.selectIndex.value]
            : const CircularProgressIndicator()),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.grey,
        ),
      ),
      label: label,
    );
  }
}
