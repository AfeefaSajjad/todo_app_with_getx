import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  RxBool isDarkMode = false.obs;

  void toggleTheme(bool value) {
    isDarkMode.value = value;

    if (isDarkMode.value) {
      Get.changeTheme(ThemeData.dark());
    } else {
      Get.changeTheme(ThemeData.light());
    }
  }
}
