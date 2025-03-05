import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:letsplay/auth/login.dart';
import 'package:letsplay/auth/signupstage2.dart';
import 'package:http/http.dart' as http;
import 'package:letsplay/utils/loader.dart';

import '../apis/all_apis.dart';
import '../utils/common_functions.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  bool _isAgeConfirmed = false;
  bool _isPrivacyConfirmed = false;
  bool _isPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;
  String phone = "";
  String userName = "";
  String password = "";
  String repeatPassword = "";

  @override
  void dispose() {
    _numberController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF000000), // Start color
                  Color(0xFF6A0572), // End color
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              ),
            ),
          ),



          // Blurring effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0), // Add transparency
              ),
            ),
          ),

          // Form Fields
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png', // Replace with your logo path
                      height: 150,
                    ),
                  ),
                  // SizedBox(height: 40),
                  Center(
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Email Field
                  TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Magical Contact Number",
                      labelStyle: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Mulish',
                      ),
                      hintText: "Magical Contact Number",
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontFamily: 'Mulish',
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purpleAccent),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your number';
                      }
                      if (value.trim().length < 10) {
                        return 'Number must have 10 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _userNameController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Choose Your Hero Name",
                      labelStyle: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Mulish',
                      ),
                      hintText: "Choose Your Hero Name",
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontFamily: 'Mulish',
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purpleAccent),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Password Field
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Secret Spell (Password)",
                      labelStyle: TextStyle(
                          color: Colors.white70, fontFamily: 'Mulish'),
                      hintText: "Secret Spell (Password)",
                      hintStyle: TextStyle(
                          color: Colors.white54, fontFamily: 'Mulish'),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purpleAccent),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white54,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

// Repeat Password Field
                  TextFormField(
                    controller: _repeatPasswordController,
                    obscureText: !_isRepeatPasswordVisible,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Confirm Spell (Password)",
                      labelStyle: TextStyle(
                          color: Colors.white70, fontFamily: 'Mulish'),
                      hintText: "Confirm Spell (Password)",
                      hintStyle: TextStyle(
                          color: Colors.white54, fontFamily: 'Mulish'),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purpleAccent),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isRepeatPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white54,
                        ),
                        onPressed: () {
                          setState(() {
                            _isRepeatPasswordVisible =
                                !_isRepeatPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please repeat your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),
                  // Checkbox for Age Confirmation
                  Row(
                    children: [
                      Checkbox(
                        value: _isAgeConfirmed,
                        onChanged: (value) {
                          setState(() {
                            _isAgeConfirmed = value!;
                          });
                        },
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.all(Colors.purple),
                      ),
                      Expanded(
                        child: Text(
                          "By checking this box, I confirm that I am at least 13 years old.",
                          style: TextStyle(
                              color: Colors.white70, fontFamily: 'Mulish'),
                        ),
                      ),
                    ],
                  ),
                  // Checkbox for Privacy and Terms
                  Row(
                    children: [
                      Checkbox(
                        value: _isPrivacyConfirmed,
                        onChanged: (value) {
                          setState(() {
                            _isPrivacyConfirmed = value!;
                          });
                        },
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.all(Colors.purple),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text:
                                "By checking this box, I agree that I have read and agree with the ",
                            style: TextStyle(
                                color: Colors.white70, fontFamily: 'Mulish'),
                            children: [
                              TextSpan(
                                text: "Privacy",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    decoration: TextDecoration.underline,
                                    fontFamily: 'Mulish'),
                                // Add a gesture recognizer here if you want to open a link
                              ),
                              TextSpan(text: " and "),
                              TextSpan(
                                text: "Terms of Service",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    decoration: TextDecoration.underline,
                                    fontFamily: 'Mulish'),
                                // Add a gesture recognizer here if you want to open a link
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Continue Button
                  Container(
                    width: double.infinity,
                    // Adjust the width as per your layout
                    height: 50,
                    // Adjust the height as needed
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFD5939),
                          Color(0xFFFD7E29),
                          Color(0xFFFDBF2E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                          12), // Adjust the radius as needed
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Call the network check and await its result.
                        hideSoftKeyboard(context);
                        bool isAvailable = await isNetworkAvailable();
                        print("signup1 $isAvailable");

                        if (isAvailable) {

                          phone = _numberController.text.toString().trim();
                          userName = _userNameController.text.toString().trim();
                          password = _passwordController.text.toString().trim();
                          repeatPassword =
                              _repeatPasswordController.text.toString().trim();

                          if (validatePhone() &&
                              validateUserName() &&
                              validatePassword() &&
                              validateCheckBoxes()) {

                            bool validateUserNameAndPhone =
                                await validateUserNameAndPhoneNumber();
                            if (validateUserNameAndPhone == true) {
                              final userData = {
                                "username": userName,
                                "password": password,
                                "image":"",
                                "pno": phone,
                                "code":"Anmol",
                              };
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Signupstage2(
                                    userData: userData,
                                    mobileNumber: phone,
                                  ),
                                ),
                              );
                            }
                          }
                        } else {
                          Get.snackbar(
                            'Error',
                            "Internet not available",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            borderRadius: 8,
                            margin: EdgeInsets.all(16),
                            duration: Duration(seconds: 3),
                            snackStyle: SnackStyle.FLOATING,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 16, fontFamily: 'Mulish', // Font size
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  // Already have an account? Log In
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Navigate to login screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Already an Gladiator?",
                          style: TextStyle(
                              color: Colors.white,
                              // White color for "Don't have an account?"
                              fontSize: 16,
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Log In',
                              style: TextStyle(
                                  color: Colors.pink,
                                  // Pink color for "Sign Up"
                                  fontSize: 16,
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validatePhone() {
    if (phone == "") {
      Get.snackbar(
        'Error',
        "Please enter valid number",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
      );
      return false;
    } else if (phone.length > 12) {
      Get.snackbar(
        'Error',
        "Please enter valid number",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
      );
      return false;
    }

    return true;
  }

  Future<bool> validateUserNameAndPhoneNumber() async {

    Loader.showLoading("Verifying username and phone number...");
    if (await isNetworkAvailable()) {
      final userData1 = {"username": userName, "pno": phone};
      try {
        final response = await http.post(
          Uri.parse(AppUrl.uniqueUsernameMobile),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData1),
        );

        print("Error during register body:${jsonEncode(userData1)}");
        print("Error during register code: ${response.statusCode}");
        final responseBody =
            jsonDecode(response.body); // Convert JSON string to Map
        final errorMessage = responseBody["message"];

        if(response.statusCode ==200){
          Loader.hideLoading();
          return true;
        }else{
          Loader.hideLoading();
          Get.snackbar(
            'Error',
            "$errorMessage",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 8,
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 3),
            snackStyle: SnackStyle.FLOATING,
          );
          return false;
        }

      } catch (e) {
        print("Error during register catch: $e");
        Loader.hideLoading();
        Get.snackbar(
          'Error',
          "Error occurred!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 8,
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 3),
          snackStyle: SnackStyle.FLOATING,
        );
        return false;
      }
    } else {
      Loader.hideLoading();
      Get.snackbar(
        'Error',
        "Internet not available",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
      );
      return false;
    }
  }

  bool validateUserName() {
    if (userName == "") {
      Get.snackbar(
        'Error',
        "Please enter valid Username",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
      );
      return false;
    }

    return true;
  }

  bool validatePassword() {
    if (password == "") {
      Get.snackbar(
        'Error',
        "Please enter valid password",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
      );
      return false;
    } else if (password != repeatPassword) {
      Get.snackbar(
        'Error',
        "Password and Confirm password don't match",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
      );
      return false;
    }

    if (repeatPassword == "") {
      Get.snackbar(
        'Error',
        "Please enter valid password",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
      );
    }
    return true;
  }

  bool validateCheckBoxes() {
    if (_isAgeConfirmed == false) {
      Get.snackbar(
        'Error',
        "Please confirm your age!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
      );
      return false;
    }
    if (_isPrivacyConfirmed == false) {
      Get.snackbar(
        'Error',
        "Please agree with our policies.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
      );
      return false;
    }

    return true;
  }
  void hideSoftKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
