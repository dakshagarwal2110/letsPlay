import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:letsplay/auth/signupstage1.dart';

import '../apis/all_apis.dart';
import '../bottom_nav.dart';
import '../utils/common_functions.dart';
import 'package:http/http.dart' as http;

import '../utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool identifierEnabled = true;
  bool passwordEnabled = true;
  bool obscurePassword = false;
  String password="";
  String identifier="";

  @override
  void initState() {
    // TODO: implement initState
    print("init state login");
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {

    hideSoftKeyboard(context);
    if (await isNetworkAvailable()) {

      setState(() {
        identifierEnabled = false;
        passwordEnabled = false;
        Loader.showLoading("Hype up! Let's Go");
      });

      final params = {
        "identifier": _emailController.text.trim(),
        "password": _passwordController.text.trim()
      };

      try {
        final response = await http.post(
          Uri.parse(AppUrl.loginUserApi),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(params),
        );

        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}"); // Print raw response for debugging

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final String username = responseData['user']['username'];
          final String accessToken = responseData['token'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          String encodedLoginData = jsonEncode(responseData);
          prefs.setString("login_data", encodedLoginData);
          prefs.setString("username", username);
          prefs.setString("accessToken", accessToken);

          //prefs.setString("accessToken", )


          // Print the username or use it as needed
          print('Login screen username: $responseData');

          Loader.hideLoading();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomBottomNavBar(),
            ),
          );
        } else {
          // Handle error response
          final Map<String, dynamic> responseBody = jsonDecode(response.body);
          final errorMessage = responseBody["message"] ?? "An error occurred";
          print("Login screen username error: $errorMessage");

          Loader.hideLoading();
          Get.snackbar(
            'Error',
            errorMessage,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 8,
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 3),
            snackStyle: SnackStyle.FLOATING,
          );

          setState(() {
            identifierEnabled = true;
            passwordEnabled = true;
            Loader.hideLoading();
          });
        }
      } catch (e) {
        print("Login screen username catch: $e");
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
        setState(() {
          identifierEnabled = true;
          passwordEnabled = true;
          Loader.hideLoading();

        });
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
                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Color(0xFFFD5939),
                          Color(0xFFFD7E29),
                          Color(0xFFFDBF2E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(
                          Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height)),
                      child: Text(
                        "TourneyB",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 33,
                          fontFamily: 'Mercenary',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      "Welcome back",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mercenary',
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    enabled: identifierEnabled,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Phone number or Username",
                      labelStyle: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Mercenary',
                      ),
                      hintText: "Enter Phone number or Username",
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontFamily: 'Mercenary',
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

                  ),
                  SizedBox(height: 20),
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !obscurePassword,
                    enabled: passwordEnabled,
                    // Obscures the text to make it secure
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Mercenary',
                      ),
                      hintText: "Enter Password",
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontFamily: 'Mercenary',
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
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white54,
                        ),
                        onPressed: () {
                          setState(() {
                            // Toggles the obscureText value for password visibility
                            obscurePassword = !obscurePassword;
                            if(obscurePassword == false){

                            }
                          });
                        },
                      ),
                    ),

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

                      onPressed: (){
                        bool valid = validation();
                        if(valid){
                          _submitForm();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        'Let’s Go',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 16,
                          fontWeight: FontWeight.bold

                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  // Already have an account? Log In
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Signup(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.white,
                            // White color for "Don't have an account?"
                            fontSize: 16,

                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                color: Colors.pink, // Pink color for "Sign Up"
                                fontSize: 16,
                                fontFamily: 'Mercenary',
                                fontWeight: FontWeight.bold,
                              ),
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

  void hideSoftKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  bool validation() {
    password = _passwordController.text.toString().trim();
    identifier = _emailController.text.toString().trim();


    if(identifier == ""){
      Get.snackbar(
        'Error',
        "ID cannot be empty",
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
    if(password == ""){
      Get.snackbar(
        'Error',
        "Password cannot be empty",
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
}
