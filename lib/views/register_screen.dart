import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/views/login_screen.dart';
import '../resources/color.dart';
import 'main_screen.dart';
import '../controllers/profile_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ProfileController profileController = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> retrieveStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');

    print('Stored Email: $storedEmail');
    print('Stored Password: $storedPassword');
  }

  Future<void> registerUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    bool emailSaved = await prefs.setString('email', email);
    bool passwordSaved = await prefs.setString('password', password);

    print('Email saved: $emailSaved');
    print('Password saved: $passwordSaved');

    await Future.delayed(Duration(milliseconds: 500));
    Get.offAll(() => const MainScreen());
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    retrieveStoredData();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

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
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 90),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: screenHeight * 0.34,
                  width: screenWidth * 0.45,
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
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.checklist_rounded,
                      color: AppTheme.primaryColor,
                      size: screenWidth * 0.28,
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor),
                          hintText: "Please enter your name",
                          hintStyle: TextStyle(color: AppTheme.textColor),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.textColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppTheme.textColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor),
                          hintText: "Please enter your email",
                          hintStyle: TextStyle(color: AppTheme.textColor),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppTheme.textColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.appBarColor),
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.email,
                            color: AppTheme.textColor,
                          ),
                        ),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor),
                          hintText: "Create strong password",
                          hintStyle: TextStyle(color: AppTheme.textColor),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.textColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: AppTheme.textColor,
                          ),
                        ),
                        validator: _validatePassword,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _forgotPassword,
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          await registerUser(
                              emailController.text, passwordController.text);

                          final prefs = await SharedPreferences.getInstance();
                          String? storedEmail = prefs.getString('email');
                          String? storedPassword = prefs.getString('password');
                          print('Stored Email: $storedEmail');
                          print('Stored Password: $storedPassword');

                          Get.offAll(() => const MainScreen());
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.buttonTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => const LoginScreen());
                  },
                  child: const Text(
                    'Already have an account? Login',
                    style:
                        TextStyle(fontSize: 16, color: AppTheme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _forgotPassword() {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Forgot Password')),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Enter new password and confirm it.'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    hintText: 'Enter new password',
                    labelStyle: TextStyle(color: AppTheme.primaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.errorColor),
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your new password',
                    labelStyle: TextStyle(color: AppTheme.primaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.errorColor),
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.of(context).pop();
                          Get.snackbar(
                            'Success',
                            'Password has been reset successfully!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppTheme.primaryColor,
                            colorText: Colors.white,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(
                          color: AppTheme.fabIconColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
