import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/controllers/profile_controller.dart';

import '../resources/color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controller = Get.put(ProfileController());
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadSavedImages();
    loadSavedUsername();
    _usernameController.text = controller.username.value;
  }

  void loadSavedUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    if (savedUsername != null) {
      setState(() {
        controller.username.value = savedUsername;
        _usernameController.text = savedUsername;
      });
    }
  }

  void _changeUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    setState(() {
      controller.username.value = _usernameController.text;
    });
  }

  void _editUsername() {
    _usernameController.text = controller.username.value;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text('Change Username')),
          content: TextField(
            controller: _usernameController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter new username'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _changeUsername();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () async {
                    await controller.pickImageFromGallery(false);
                  },
                  child: Obx(() {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.25,
                          decoration: BoxDecoration(
                            image: controller.coverImage.value != null
                                ? DecorationImage(
                                    image:
                                        FileImage(controller.coverImage.value!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: AppTheme.appBarColor,
                          ),
                        ),
                        Positioned(
                          bottom: 8.0,
                          right: 8.0,
                          child: PopupMenuButton<String>(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.white),
                            onSelected: (value) async {
                              if (value == 'Select Image') {
                                await controller.pickImageFromGallery(false);
                              } else if (value == 'Delete Image') {
                                controller.coverImage.value =
                                    null; // Reset cover image
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'Select Image',
                                child: Text('Select Image'),
                              ),
                              const PopupMenuItem(
                                value: 'Delete Image',
                                child: Text('Delete Image'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                Positioned(
                  left: 16.0,
                  top: screenHeight * 0.25 - (screenWidth * 0.15),
                  child: GestureDetector(
                    onTap: () async {
                      await controller.pickImageFromGallery(true);
                    },
                    child: Obx(() {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: controller.profileImage.value != null
                                  ? DecorationImage(
                                      image: FileImage(
                                          controller.profileImage.value!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          if (controller.profileImage.value == null)
                            const Icon(Icons.person, size: 90),
                          if (controller.profileImage.value == null)
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: Material(
                                color: Colors.transparent,
                                child: SizedBox(
                                  height: 64,
                                  width: 64,
                                  child: PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 34,
                                    ),
                                    onSelected: (value) async {
                                      if (value == 'Select Image') {
                                        await controller
                                            .pickImageFromGallery(true);
                                      } else if (value == 'Delete Image') {
                                        controller.profileImage.value = null;
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'Select Image',
                                        child: Text('Select Image'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'Delete Image',
                                        child: Text('Delete Image'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              onTap: _editUsername,
              contentPadding:
                  const EdgeInsets.only(left: 30.0, right: 16.0, top: 40.0),
              leading: Icon(
                Icons.edit,
                color: AppTheme.textColor.withOpacity(0.9),
              ),
              title: const Text(
                'Change username',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textColor,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              onTap: () async {
                await controller.pickImageFromGallery(true);
              },
              contentPadding:
                  const EdgeInsets.only(left: 30.0, right: 16.0, top: 10.0),
              leading: Icon(
                Icons.photo_camera,
                color: AppTheme.textColor.withOpacity(0.9),
              ),
              title: const Text(
                'Change profile photo',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textColor,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              onTap: () async {
                await controller.pickImageFromGallery(false);
              },
              contentPadding:
                  const EdgeInsets.only(left: 30.0, right: 16.0, top: 10.0),
              leading: Icon(
                Icons.image,
                color: AppTheme.textColor.withOpacity(0.9),
              ),
              title: const Text(
                'Change cover photo',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
