import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pet_adoption_app/helper/navigation_icon_controller.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationIconController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
            elevation: 0,
            height: 80,
             indicatorColor:  const Color.fromARGB(255, 240, 224, 84),
            selectedIndex: controller.selectIndex.value,
            onDestinationSelected: (index) =>
                {controller.selectIndex.value = index},
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.add),
                label: 'Add',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_sharp),
                label: 'Chats',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_box_sharp),
                label: 'Profile',
              ),
            ]),
      ),
      body: Obx(() => controller.screens[controller.selectIndex.value]),
    );
  }
}
