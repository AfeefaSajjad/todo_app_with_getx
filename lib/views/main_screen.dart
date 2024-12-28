import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/views/profile_screen.dart';

import '../controllers/navigator_controller.dart';
import '../controllers/profile_controller.dart';
import '../resources/color.dart';
import 'drawer_screen.dart';
import 'filter_screen.dart';
import 'setting_screen.dart';
import 'task_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final NavigationController navigationController =
      Get.put(NavigationController());
  final ProfileController profileController = Get.put(ProfileController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const TaskScreen(),
    const FilteredTaskScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: AppTheme.primaryColor,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Obx(() {
              String username = profileController.username.value;
              String userInitial =
                  username.isNotEmpty ? username[0].toUpperCase() : '';
              return CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  userInitial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Obx(() {
        return _screens[navigationController.currentIndex.value];
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navigationController.currentIndex.value,
          onTap: (index) {
            navigationController.changeIndex(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_sharp),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_sharp),
              label: 'Task View',
            ),
            BottomNavigationBarItem(
              // Profile Screen item
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.subtitleTextColor,
          backgroundColor: AppTheme.backgroundColor,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
