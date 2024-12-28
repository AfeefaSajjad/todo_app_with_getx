import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  Rx<File?> coverImage = Rx<File?>(null);
  Rx<File?> profileImage = Rx<File?>(null);
  var username = ''.obs;
  final String coverImageKey = 'coverImagePath';
  final String profileImageKey = 'profileImagePath';

  @override
  void onInit() {
    super.onInit();
    loadSavedImages();
  }

  Future<void> pickImageFromGallery(bool isProfile) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final pickedImage = File(pickedFile.path);
      if (isProfile) {
        profileImage.value = pickedImage;
        await saveImagePath(profileImageKey, pickedFile.path);
      } else {
        coverImage.value = pickedImage;
        await saveImagePath(coverImageKey, pickedFile.path);
      }
    }
  }

  Future<void> saveImagePath(String key, String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, path);
  }

  Future<void> loadSavedImages() async {
    final prefs = await SharedPreferences.getInstance();
    final coverImagePath = prefs.getString(coverImageKey);
    final profileImagePath = prefs.getString(profileImageKey);

    if (coverImagePath != null) {
      coverImage.value = File(coverImagePath);
    }

    if (profileImagePath != null) {
      profileImage.value = File(profileImagePath);
    }
  }
  Future<void> updateUsername(String newUsername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', newUsername);
    username.value = newUsername;
  }
  Future<void> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? '';
  }
}
