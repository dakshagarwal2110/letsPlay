import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:letsplay/auth/login.dart';
import 'package:letsplay/auth/splash_screen.dart';

import 'auth/signupstage1.dart';
import 'bottom_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(

        fontFamily: GoogleFonts.mulish().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2B2E52)),
        useMaterial3: true,
      ),
        getPages: [
         // GetPage(name: '/', page: () => const WelcomeScreen()), // Define the initial route page
          GetPage(name: '/login', page: () => Login()),


        ],
      home: const SplashScreen()
    );
  }
}





















