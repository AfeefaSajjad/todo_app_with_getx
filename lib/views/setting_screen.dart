import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/color.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('isLoggedIn');

    Get.offAll(() =>const LoginScreen());
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.only(top: screenHeight * 0.003, left: screenWidth * 0.02, right: screenWidth * 0.02),
        children: [
          _buildExpansionTile(
            context,
            icon: Icons.info_outline,
            title: 'About App',
            children: [
              _buildSubExpansionTile(
                title: 'What is this app about?',
                description: 'This app helps users efficiently manage and track their tasks.',
              ),
              _buildSubExpansionTile(
                title: 'Who can use this app?',
                description: 'This app is suitable for anyone looking to organize tasks, such as students, professionals, and freelancers.',
              ),
              _buildSubExpansionTile(
                title: 'What platforms does the app support?',
                description: 'The app is available on Android and iOS platforms.',
              ),
            ],
          ),
          _buildExpansionTile(
            context,
            icon: Icons.help_outline,
            title: 'FAQs',
            children: [
              _buildSubExpansionTile(
                title: 'How do I add a new task?',
                description: 'To add a new task, click the "+" button on the home screen. Fill in the task details and press "Save".',
              ),
              _buildSubExpansionTile(
                title: 'How do I mark a task as completed?',
                description: 'On the task list, use the checkbox next to each task to mark it as completed.',
              ),
              _buildSubExpansionTile(
                title: 'Can I edit a task?',
                description: 'Yes, tap on a task to view its details and use the "Edit" button to modify it.',
              ),
              _buildSubExpansionTile(
                title: 'How do I delete a task?',
                description: 'Tap on a task to view its details and use the "Delete" button to remove it.',
              ),
            ],
          ),
          _buildExpansionTile(
            context,
            icon: Icons.chat_bubble_outline,
            title: 'General Questions',
            children: [
              _buildSubExpansionTile(
                title: 'How to use the app?',
                description: 'Step 1: Login\nStep 2: Add tasks\nStep 3: Track tasks.',
              ),
              _buildSubExpansionTile(
                title: 'Can I use the app offline?',
                description: 'The app requires an internet connection for syncing tasks but allows offline access for viewing existing tasks.',
              ),
            ],
          ),
          _buildExpansionTile(
            context,
            icon: Icons.thumb_up_alt_outlined,
            title: 'Help & Feedback',
            children: [
              _buildSubExpansionTile(
                title: 'Contact Information',
                description: 'If you have any questions or suggestions, please contact us at support@example.com.',
              ),
              _buildSubExpansionTile(
                title: 'Support Us',
                description: 'Support us by rating our app and sharing it with your friends!',
              ),
            ],
          ),
          ListTile(
            leading:const Icon(
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

  Widget _buildExpansionTile(BuildContext context,
      {required IconData icon,
      required String title,
      required List<Widget> children}) {
    return ExpansionTile(
      leading: Icon(
        icon,

        color: AppTheme.textColor.withOpacity(0.9),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textColor,
          fontWeight: FontWeight.w300,
          fontSize: 18,
        ),
      ),
      collapsedIconColor: AppTheme.textColor,
      iconColor: AppTheme.textColor,
      children: children,
    );
  }

  Widget _buildSubExpansionTile(
      {required String title, required String description}) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textColor,
          fontWeight: FontWeight.w400,
          fontSize: 17,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            description,
            style: const TextStyle(
              color: AppTheme.secondaryTextColor,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),

      ],
    );
  }
}
