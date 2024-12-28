import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/navigator_controller.dart';
import '../controllers/profile_controller.dart';
import '../resources/color.dart';
import '../views/login_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String userEmail = '';

  Future<void> _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email') ?? 'No email found';
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('isLoggedIn');
    await prefs.remove('profileImage');

    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.find();
    final ProfileController profileController = Get.find();

    double screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  double avatarSize = screenWidth * 0.18;
                  return CircleAvatar(
                    radius: avatarSize / 2,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        profileController.profileImage.value != null
                            ? FileImage(profileController.profileImage.value!)
                            : const AssetImage('assets/default_avatar.png')
                                as ImageProvider,
                    foregroundColor: Colors.transparent,
                    child: profileController.profileImage.value == null
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  );
                }),
                const SizedBox(height: 10),
                Text(
                  'Welcome, $userEmail',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              navigationController.changeIndex(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.task_alt),
            title: const Text('Task View'),
            onTap: () {
              navigationController.changeIndex(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              navigationController.changeIndex(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              navigationController.changeIndex(3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: AppTheme.errorColor,
            ),
            title: const Text(
              'Log Out',
              style: TextStyle(
                color: AppTheme.errorColor,
              ),
            ),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
