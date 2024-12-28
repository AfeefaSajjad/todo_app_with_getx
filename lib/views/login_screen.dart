import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/views/main_screen.dart';
import '../resources/color.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final prefs = await SharedPreferences.getInstance();
      final String? storedEmail = prefs.getString('email');
      final String? storedPassword = prefs.getString('password');

      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      if (email == storedEmail && password == storedPassword) {
        await prefs.setBool('isLoggedIn', true);

        setState(() {
          _isLoading = false;
        });

        Get.offAll(() => MainScreen());

        Get.snackbar(
          'Success',
          'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.primaryColor,
          colorText: Colors.white,
        );
      } else {
        setState(() {
          _isLoading = false;
        });

        Get.snackbar(
          'Error',
          'Invalid email or password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
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
            padding: const EdgeInsets.only(
                top: 60, left: 20, right: 20, bottom: 150),
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
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18.0),
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
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.appBarColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppTheme.textColor,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: AppTheme.textColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: .0),
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
                      const SizedBox(height: 0.0),
                      _isLoading
                          ? const CircularProgressIndicator(
                              color: AppTheme.primaryColor)
                          : ElevatedButton(
                              onPressed: () async {
                                final email = emailController.text.trim();
                                final password = passwordController.text.trim();

                                if (email.isNotEmpty && password.isNotEmpty) {
                                  await _loginUser(); // Call login logic
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'Email and password cannot be empty',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                backgroundColor: AppTheme.primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.buttonTextColor,
                                ),
                              ),
                            ),
                      const SizedBox(height: 0.0),
                      TextButton(
                        onPressed: () {
                          Get.to(() => RegisterScreen());
                        },
                        child: const Text(
                          'Don’t have an account? Register',
                          style: TextStyle(
                              fontSize: 16, color: AppTheme.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
