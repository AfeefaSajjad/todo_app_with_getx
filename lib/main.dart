import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/views/loading_screen.dart';
import 'package:todo_app/views/login_screen.dart';

import 'controllers/profile_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ProfileController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: BindingsBuilder(() {}),
        home: LoadingScreen());
  }
}
