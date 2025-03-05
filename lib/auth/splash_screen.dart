import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:letsplay/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bottom_nav.dart';
import '../utils/app_size.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _dotsController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _dotsController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    _timer = Timer(const Duration(seconds: 2), _checkAuthentication);
  }

  @override
  void dispose() {
    _dotsController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _checkAuthentication() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    final String? username = prefs.getString('username');
    final String? loginData = prefs.getString('login_data');

    if (accessToken == null ||
        accessToken.isEmpty ||
        username == null ||
        username.isEmpty ||
        loginData == null ||
        loginData.isEmpty) {
      _navigateToLogin();
    } else {
      print("login_data is $loginData");

      final bool isAuthenticated = await _checkAuthWithAPI(accessToken);
      if (isAuthenticated) {
        _navigateToHome();
      } else {
         _navigateToLogin();
      }
    }
  }

  Future<bool> _checkAuthWithAPI(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://tourneyb-backend.vercel.app/api/v1/auth/checkAuth'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print("splash_screen ");
      final Map<String, dynamic> responseData = json.decode(response.body);
      print("splash_screen $responseData");

      return responseData['success'] == true;
    }
    print("splash_screen ${response.statusCode}");

    return false;
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CustomBottomNavBar(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2B2E52),
              Color(0xFF994FEE),
              Color(0xFF2B2E52),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with subtle scaling animation
              AnimatedScale(
                scale: 1.1,
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              // Custom CircularProgressIndicator with size and color adjustments
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),

                ),
              ),
              const SizedBox(height: 20),
              // Text with animated dots
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       "Please wait",
              //       style: TextStyle(
              //         color: Colors.orangeAccent,
              //         fontSize: 24,
              //         fontFamily: 'Mercenary',
              //         fontWeight: FontWeight.bold,
              //         letterSpacing: 1.2,
              //       ),
              //     ),
              //     // Animated dots for loading effect
              //     AnimatedBuilder(
              //       animation: _dotsController,
              //       builder: (context, child) {
              //         int dots = (_dotsController.value * 5).round() % 6;
              //         return Text(
              //           '.' * dots,
              //           style: const TextStyle(
              //             fontSize: 24,
              //             color: Colors.orangeAccent,
              //           ),
              //         );
              //       },
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              // Subtle pulsing animation for a "Loading" label below
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.8, end: 1.0),
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Text(
                      "Loading...",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  );
                },
                onEnd: () => setState(() {}),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
