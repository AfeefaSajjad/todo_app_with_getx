import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/color.dart';
import 'login_screen.dart';
import 'main_screen.dart';
import 'register_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
    // _navigateToAppropriateScreen();
    // _checkLoginStatus();
  }

  Future<void> _checkUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isRegistered = prefs.getBool('isRegistered') ?? false;
    final String? email = prefs.getString('email');

    Future.delayed(const Duration(seconds: 2), () {
      if (isRegistered) {
        if (email != null) {
          Get.offAll(() => const MainScreen());
        } else {
          Get.offAll(() => const LoginScreen());
        }
      } else {
        Get.offAll(() => RegisterScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor,
              AppTheme.primaryColor.withOpacity(0.8),
              AppTheme.surfaceColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: screenHeight * 0.15,
                width: screenWidth * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white,
                      AppTheme.primaryColor.withOpacity(0.5),
                    ],
                    center: Alignment.center,
                    radius: 0.9,
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.checklist_rounded,
                    color: AppTheme.primaryColor,
                    size: screenWidth * 0.12,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              // App Name with Enhanced Typography
              Text(
                'To-Do App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Stay organized with ease',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: screenWidth * 0.045,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: screenHeight * 0.06),

              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
